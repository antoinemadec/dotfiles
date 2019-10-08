#/bin/sh

get_window_nb(){
  wmctrl -l | wc -l
}

wait_on_window_nb(){
  goal_nb=$1
  while [ $goal_nb -gt $(get_window_nb) ]
  do
    :
  done
}

exec_i3_msg_and_wait(){
  msg="$1"
  wait_window="$2"
  nb=$(get_window_nb)
  i3-msg "$msg"
  i3-msg -t sync
  [ "$wait_window" = 1 ] && wait_on_window_nb $((nb + 1))
}


# x11vnc -forever -rfbauth .vnc/passwd
# i3-msg 'exec --no-startup-id ~/bin/ghost-text-vim/ghost-text-server.tcl'
sleep 2
exec_i3_msg_and_wait 'workspace 1:email'
exec_i3_msg_and_wait 'exec --no-startup-id firefox mail.zoho.com http://10.1.10.119:9090 dinoplus.atlassian.net gitlab.com' 1
exec_i3_msg_and_wait 'layout tabbed'
exec_i3_msg_and_wait 'exec --no-startup-id termite -e htop' 1
exec_i3_msg_and_wait 'exec --no-startup-id termite -e "ssh -t $(cat ~/remote_machine.txt) htop"' 1
exec_i3_msg_and_wait 'focus left; focus left'
