"""
Choose what backgound image to display
"""

import os


class Py3status:
    cache_timeout = 10
    full_text = 'bg'
    button_next = 5
    button_prev = 4

    def battery_acpi(self):
        arr = self.py3.command_output('acpi').split(',')
        if arr[0].find("Discharging") != -1:
            icon = "🔋"
        else:
            icon = "⚡"
        pct = arr[1].strip()
        return {
                'full_text': icon + " " + pct,
                'cached_until': self.py3.time_in(self.cache_timeout)
                }
