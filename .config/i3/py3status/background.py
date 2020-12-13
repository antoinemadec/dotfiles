"""
Choose what backgound image to display
"""

import os


class Py3status:
    cache_timeout = 2
    home_dir = os.getenv("HOME")
    wallpaper_dir = os.path.expanduser('~/.config/i3/wallpaper')
    default_wallpaper = os.path.join(wallpaper_dir, "default")
    wallpaper_list = sorted([f for f in os.listdir(wallpaper_dir)
                             if f not in ("default", "standardize_names","get_average_val.sh", "change_wallpaper.sh", "avg_val_top_right.txt")])
    img_idx = wallpaper_list.index(os.path.basename(os.path.realpath(default_wallpaper)))
    output = 'background'
    format = '{output}'
    button_next = 5
    button_prev = 4

    def background(self):
        return {
            'full_text': self.py3.safe_format(self.format, {'output': self.output}),
            'cached_until': self.py3.time_in(self.cache_timeout)
        }

    def on_click(self, event):
        if event['button'] == self.button_prev:
            delta = -1
        elif event['button'] == self.button_next:
            delta = 1
        else:
            target = os.path.join(self.wallpaper_dir, self.wallpaper_list[self.img_idx])
            self.output = 'background'
            self.py3.command_run("ln -sf %s %s" % (target, self.default_wallpaper))
            return
        self.img_idx = (self.img_idx + delta) % len(self.wallpaper_list)
        next_wallpaper = self.wallpaper_list[self.img_idx]
        next_wallpaper_path = os.path.join(self.wallpaper_dir, next_wallpaper)
        self.py3.command_run("feh --bg-scale %s" % next_wallpaper_path)
        self.output = next_wallpaper.split('.')[0]
        self.py3.command_run(os.path.join(
            self.wallpaper_dir, 'change_wallpaper.sh') + ' ' + next_wallpaper_path)
