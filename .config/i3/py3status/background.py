"""
Choose what backgound image to display
"""

import os


class Py3status:
    cache_timeout = 2
    wallpaper_dir = os.path.expanduser('~/.config/i3/wallpaper')
    default_wallpaper = os.path.join(wallpaper_dir, "default")
    wallpaper_list = sorted([f for f in os.listdir(wallpaper_dir)
                             if f not in ("default", "standardize_names")])
    img_idx = wallpaper_list.index(os.path.basename(os.path.realpath(default_wallpaper)))
    full_text = 'bg'
    button_next = 5
    button_prev = 4

    def background(self):
        return {
                'full_text': self.full_text,
                'cached_until': self.py3.time_in(self.cache_timeout)
                }

    def on_click(self, event):
        if event['button'] == self.button_prev:
            delta = -1
        elif event['button'] == self.button_next:
            delta = 1
        else:
            target = os.path.join(self.wallpaper_dir, self.wallpaper_list[self.img_idx])
            self.py3.command_run("ln -sf %s %s" % (target, self.default_wallpaper))
            return
        self.img_idx = (self.img_idx + delta) % len(self.wallpaper_list)
        next_wallpaper = self.wallpaper_list[self.img_idx]
        self.py3.command_run("feh --bg-scale %s" % os.path.join(self.wallpaper_dir, next_wallpaper))
        self.full_text = next_wallpaper.split('.')[0]
