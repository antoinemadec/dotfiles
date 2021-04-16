"""
Choose what backgound image to display
"""


class Py3status:
    cache_timeout = 10
    output = ''
    format = '{output}'
    button_next = 5
    button_prev = 4

    def battery_acpi(self):
        arr = self.py3.command_output('acpi').split("\n")[0].split(',')
        if arr[0].find("Discharging") != -1:
            icon = "🔋"
        else:
            icon = "⚡"
        pct = arr[1].strip()
        self.output = icon + " " + pct
        return {
            'full_text': self.py3.safe_format(self.format, {'output': self.output}),
            'cached_until': self.py3.time_in(self.cache_timeout)
        }
