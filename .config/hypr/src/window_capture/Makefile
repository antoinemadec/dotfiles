# Build window_capture, used by ~/.config/hypr/bin/window_thumbnails
# Dependencies: libwayland-dev, libpng-dev, wayland-scanner

OUT ?= window_capture
PROTOCOL = hyprland-toplevel-export-v1
GEN = $(dir $(OUT))gen

$(OUT): window_capture.c $(GEN)/$(PROTOCOL)-client-protocol.h $(GEN)/$(PROTOCOL)-protocol.c
	$(CC) -O2 -Wall -I$(GEN) -o $@ window_capture.c $(GEN)/$(PROTOCOL)-protocol.c \
		$$(pkg-config --cflags --libs wayland-client libpng)

$(GEN)/$(PROTOCOL)-client-protocol.h: $(PROTOCOL).xml
	mkdir -p $(GEN)
	wayland-scanner client-header $< $@

$(GEN)/$(PROTOCOL)-protocol.c: $(PROTOCOL).xml
	mkdir -p $(GEN)
	wayland-scanner private-code $< $@
