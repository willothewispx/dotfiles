#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log
echo "---" | tee -a /tmp/polybar2.log
polybar main >>/tmp/polybar1.log 2>&1 & disown
polybar secondary >>/tmp/polybar2.log 2>&1 & disown

echo "Bars launched..."
