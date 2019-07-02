#/bin/sh

# ~/bin/ghost-text-vim/ghost-text-server.tcl &
# x11vnc -forever -rfbauth .vnc/passwd
sleep .7
i3-msg 'workspace 1:email; exec firefox mail.zoho.com dinoplus.atlassian.net gitlab.com'
sleep 1
i3-msg 'layout tabbed'
i3-msg 'exec termite -e htop'
i3-msg 'exec termite -e "ssh -t $(cat ~/remote_machine.txt) htop"'
sleep .3
i3-msg 'focus left; focus left'
