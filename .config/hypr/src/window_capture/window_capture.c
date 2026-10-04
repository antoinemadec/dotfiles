// Capture Hyprland windows to downscaled PNG files, even the windows on
// hidden workspaces, using the hyprland_toplevel_export_v1 protocol.
//
// Usage: window_capture <max_width> <out_dir> <address>...
// Writes <out_dir>/<address>.png for each window that could be captured.

#define _GNU_SOURCE
#include <png.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <wayland-client.h>

#include "hyprland-toplevel-export-v1-client-protocol.h"

// Referenced by the protocol's version 2 request, which is not used here
const struct wl_interface zwlr_foreign_toplevel_handle_v1_interface = {
    "zwlr_foreign_toplevel_handle_v1", 3, 0, NULL, 0, NULL,
};

static struct wl_shm *shm;
static struct hyprland_toplevel_export_manager_v1 *export_manager;

struct capture {
    uint32_t format, width, height, stride;
    bool has_buffer, y_invert, done, ok;
    struct wl_buffer *buffer;
    void *data;
    size_t size;
};

static void registry_global(void *data, struct wl_registry *registry,
                            uint32_t name, const char *interface,
                            uint32_t version) {
    if (strcmp(interface, wl_shm_interface.name) == 0)
        shm = wl_registry_bind(registry, name, &wl_shm_interface, 1);
    else if (strcmp(interface, hyprland_toplevel_export_manager_v1_interface.name) == 0)
        export_manager = wl_registry_bind(
            registry, name, &hyprland_toplevel_export_manager_v1_interface, 1);
}

static void registry_global_remove(void *data, struct wl_registry *registry,
                                   uint32_t name) {}

static const struct wl_registry_listener registry_listener = {
    .global = registry_global,
    .global_remove = registry_global_remove,
};

static bool format_supported(uint32_t format) {
    return format == WL_SHM_FORMAT_ARGB8888 || format == WL_SHM_FORMAT_XRGB8888 ||
           format == WL_SHM_FORMAT_ABGR8888 || format == WL_SHM_FORMAT_XBGR8888;
}

static void frame_buffer(void *data, struct hyprland_toplevel_export_frame_v1 *frame,
                         uint32_t format, uint32_t width, uint32_t height,
                         uint32_t stride) {
    struct capture *c = data;
    if (c->has_buffer || !format_supported(format))
        return;
    c->format = format;
    c->width = width;
    c->height = height;
    c->stride = stride;
    c->has_buffer = true;
}

static void frame_damage(void *data, struct hyprland_toplevel_export_frame_v1 *frame,
                         uint32_t x, uint32_t y, uint32_t width, uint32_t height) {}

static void frame_flags(void *data, struct hyprland_toplevel_export_frame_v1 *frame,
                        uint32_t flags) {
    struct capture *c = data;
    c->y_invert = flags & HYPRLAND_TOPLEVEL_EXPORT_FRAME_V1_FLAGS_Y_INVERT;
}

static void frame_ready(void *data, struct hyprland_toplevel_export_frame_v1 *frame,
                        uint32_t tv_sec_hi, uint32_t tv_sec_lo, uint32_t tv_nsec) {
    struct capture *c = data;
    c->ok = true;
    c->done = true;
}

static void frame_failed(void *data, struct hyprland_toplevel_export_frame_v1 *frame) {
    struct capture *c = data;
    c->done = true;
}

static void frame_linux_dmabuf(void *data, struct hyprland_toplevel_export_frame_v1 *frame,
                               uint32_t format, uint32_t width, uint32_t height) {}

static void frame_buffer_done(void *data, struct hyprland_toplevel_export_frame_v1 *frame) {
    struct capture *c = data;
    if (!c->has_buffer) {
        c->done = true;
        return;
    }
    c->size = (size_t)c->stride * c->height;
    int fd = memfd_create("window_capture", MFD_CLOEXEC);
    if (fd < 0 || ftruncate(fd, c->size) < 0) {
        c->done = true;
        return;
    }
    c->data = mmap(NULL, c->size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (c->data == MAP_FAILED) {
        c->data = NULL;
        close(fd);
        c->done = true;
        return;
    }
    struct wl_shm_pool *pool = wl_shm_create_pool(shm, fd, c->size);
    c->buffer = wl_shm_pool_create_buffer(pool, 0, c->width, c->height, c->stride,
                                          c->format);
    wl_shm_pool_destroy(pool);
    close(fd);
    hyprland_toplevel_export_frame_v1_copy(frame, c->buffer, 1);
}

static const struct hyprland_toplevel_export_frame_v1_listener frame_listener = {
    .buffer = frame_buffer,
    .damage = frame_damage,
    .flags = frame_flags,
    .ready = frame_ready,
    .failed = frame_failed,
    .linux_dmabuf = frame_linux_dmabuf,
    .buffer_done = frame_buffer_done,
};

// Box-filter downscale to at most max_width, then write an RGB PNG
static bool write_png(const struct capture *c, int max_width, const char *path) {
    int factor = (c->width + max_width - 1) / max_width;
    if (factor < 1)
        factor = 1;
    int out_w = c->width / factor, out_h = c->height / factor;
    if (out_w < 1 || out_h < 1)
        return false;
    bool bgr = c->format == WL_SHM_FORMAT_ARGB8888 || c->format == WL_SHM_FORMAT_XRGB8888;

    uint8_t *rgb = malloc((size_t)out_w * out_h * 3);
    if (!rgb)
        return false;
    for (int y = 0; y < out_h; y++) {
        for (int x = 0; x < out_w; x++) {
            uint32_t sum[3] = {0, 0, 0};
            for (int dy = 0; dy < factor; dy++) {
                int sy = y * factor + dy;
                if (c->y_invert)
                    sy = c->height - 1 - sy;
                const uint8_t *row = (const uint8_t *)c->data + (size_t)sy * c->stride;
                for (int dx = 0; dx < factor; dx++) {
                    const uint8_t *px = row + (size_t)(x * factor + dx) * 4;
                    // little-endian: ARGB/XRGB are B,G,R,A bytes; ABGR/XBGR are R,G,B,A
                    sum[0] += px[bgr ? 2 : 0];
                    sum[1] += px[1];
                    sum[2] += px[bgr ? 0 : 2];
                }
            }
            uint8_t *out = rgb + ((size_t)y * out_w + x) * 3;
            for (int i = 0; i < 3; i++)
                out[i] = sum[i] / (factor * factor);
        }
    }

    char tmp_path[4096];
    snprintf(tmp_path, sizeof(tmp_path), "%s.tmp", path);
    FILE *f = fopen(tmp_path, "wb");
    png_structp png = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
    png_infop info = png ? png_create_info_struct(png) : NULL;
    bool ok = f && png && info && !setjmp(png_jmpbuf(png));
    if (ok) {
        png_init_io(png, f);
        png_set_compression_level(png, 1);
        png_set_IHDR(png, info, out_w, out_h, 8, PNG_COLOR_TYPE_RGB, PNG_INTERLACE_NONE,
                     PNG_COMPRESSION_TYPE_DEFAULT, PNG_FILTER_TYPE_DEFAULT);
        png_write_info(png, info);
        for (int y = 0; y < out_h; y++)
            png_write_row(png, rgb + (size_t)y * out_w * 3);
        png_write_end(png, NULL);
    }
    png_destroy_write_struct(&png, &info);
    if (f)
        fclose(f);
    free(rgb);
    ok = ok && rename(tmp_path, path) == 0;
    if (!ok)
        unlink(tmp_path);
    return ok;
}

static bool capture_window(struct wl_display *display, uint32_t handle, int max_width,
                           const char *path) {
    struct capture c = {0};
    struct hyprland_toplevel_export_frame_v1 *frame =
        hyprland_toplevel_export_manager_v1_capture_toplevel(export_manager, 0, handle);
    hyprland_toplevel_export_frame_v1_add_listener(frame, &frame_listener, &c);
    while (!c.done && wl_display_dispatch(display) != -1)
        ;
    bool ok = c.ok && write_png(&c, max_width, path);
    hyprland_toplevel_export_frame_v1_destroy(frame);
    if (c.buffer)
        wl_buffer_destroy(c.buffer);
    if (c.data)
        munmap(c.data, c.size);
    return ok;
}

int main(int argc, char **argv) {
    if (argc < 4) {
        fprintf(stderr, "usage: %s <max_width> <out_dir> <address>...\n", argv[0]);
        return 2;
    }
    int max_width = atoi(argv[1]);
    const char *out_dir = argv[2];
    if (max_width < 1) {
        fprintf(stderr, "invalid max_width: %s\n", argv[1]);
        return 2;
    }

    struct wl_display *display = wl_display_connect(NULL);
    if (!display) {
        fprintf(stderr, "cannot connect to the Wayland display\n");
        return 1;
    }
    struct wl_registry *registry = wl_display_get_registry(display);
    wl_registry_add_listener(registry, &registry_listener, NULL);
    wl_display_roundtrip(display);
    if (!shm || !export_manager) {
        fprintf(stderr, "compositor lacks wl_shm or hyprland_toplevel_export_v1\n");
        return 1;
    }

    int failed = 0;
    for (int i = 3; i < argc; i++) {
        // Hyprland identifies windows by the lower 32 bits of their address
        uint32_t handle = (uint32_t)strtoull(argv[i], NULL, 16);
        char path[4096];
        snprintf(path, sizeof(path), "%s/%s.png", out_dir, argv[i]);
        if (!capture_window(display, handle, max_width, path)) {
            fprintf(stderr, "failed to capture %s\n", argv[i]);
            failed++;
        }
    }

    wl_display_disconnect(display);
    return failed ? 1 : 0;
}
