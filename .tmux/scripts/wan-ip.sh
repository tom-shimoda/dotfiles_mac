#!/usr/bin/env bash
tmp_file="/tmp/tmux-wan-ip.txt"
update_period=900

if [ -f "$tmp_file" ]; then
    last_update=$(stat -f "%m" "$tmp_file" 2>/dev/null || stat -c "%Y" "$tmp_file" 2>/dev/null)
    time_now=$(date +%s)
    if [ $((time_now - last_update)) -lt $update_period ]; then
        cat "$tmp_file"
        exit 0
    fi
fi

wan_ip=$(curl -4 --max-time 2 -s http://ifconfig.me 2>/dev/null)
if [ -n "$wan_ip" ]; then
    echo "$wan_ip" > "$tmp_file"
    echo "$wan_ip"
elif [ -f "$tmp_file" ]; then
    cat "$tmp_file"
fi
