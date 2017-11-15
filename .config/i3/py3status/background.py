"""
Choose what backgound image to display
"""

import os

class Py3status:
    cache_timeout = 2
    wallpaper_dir = os.path.expanduser('~/.config/i3/wallpaper')
    img_idx = 0
    full_text = 'bg'
    def rhythmbox(self):
        return {
                'full_text': self.full_text,
                'cached_until': self.py3.time_in(self.cache_timeout)
                }

    def on_click(self, event):
        button         = event['button']
        wallpaper_list = os.listdir(self.wallpaper_dir)
        next_wallpaper = wallpaper_list[self.img_idx]
        self.py3.command_run("feh --bg-scale %s" % os.path.join(self.wallpaper_dir, next_wallpaper))
        self.full_text = next_wallpaper.split('.')[0]
        self.img_idx   = (self.img_idx + 1) % len(wallpaper_list)
