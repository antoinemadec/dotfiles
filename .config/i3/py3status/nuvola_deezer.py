"""
Control Nuvola Deezer
"""

import subprocess

class Py3status:
    cache_timeout = 4
    format = '{status}: {artist} - {title}'
    deezer_ctl = "flatpak run --command=nuvolactl eu.tiliado.Nuvola"
    button_next = 5
    button_prev = 4

    def nuvola_deezer(self):
        f_dict = {}
        try:
            if self.py3.command_output(self.deezer_ctl + " track-info state").strip('\n') == 'playing':
                f_dict['status'] = "🎵"
            else:
                f_dict['status'] = "⏯"
            f_dict['artist'] = self.py3.command_output(self.deezer_ctl + " track-info artist").strip('\n')
            f_dict['title'] = self.py3.command_output(self.deezer_ctl + " track-info title").strip('\n')
            full_text = self.py3.safe_format(self.format, f_dict)
        except:
            full_text = 'deezer'
        return {
                'full_text': full_text,
                'cached_until': self.py3.time_in(self.cache_timeout)
                }

    def on_click(self, event):
        button = event['button']
        if button == self.button_prev:
            self.py3.command_run(self.deezer_ctl + " action prev-song")
        elif button == self.button_next:
            self.py3.command_run(self.deezer_ctl + " action next-song")
        elif self.py3.command_run(self.deezer_ctl + " action toggle-play") != 0:
            subprocess.Popen(["flatpak", "run", "eu.tiliado.NuvolaAppDeezer"])
        self.nuvola_deezer()
