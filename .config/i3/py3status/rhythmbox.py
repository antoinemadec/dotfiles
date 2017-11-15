"""
Control rhythm box.
"""

class Py3status:
    cache_timeout = 4
    format = '♫: {artist} - {title}'

    def rhythmbox(self):
        f_dict = {}
        if self.py3.command_run('rhythmbox-client --check-running') == 0:
            f_dict['artist'] = self.py3.command_output('rhythmbox-client --print-playing-format "%aa"').strip('\n')
            f_dict['album']  = self.py3.command_output('rhythmbox-client --print-playing-format "%at"').strip('\n')
            f_dict['title']  = self.py3.command_output('rhythmbox-client --print-playing-format "%tt"').strip('\n')
            f_tmp = self.format
        else:
            f_tmp = ''
        return {
                'full_text': self.py3.safe_format(f_tmp, f_dict),
                'cached_until': self.py3.time_in(self.cache_timeout)
                }

    def on_click(self, event):
        button = event['button']
        self.py3.command_run('rhythmbox-client --play-pause')
