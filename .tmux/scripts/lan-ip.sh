#!/usr/bin/env bash
if command -v ip >/dev/null 2>&1; then
    ip addr show | awk '/inet / && !/127.0.0.1/{print $2}' | cut -d/ -f1 | head -1
else
    ifconfig | awk '/inet / && !/127.0.0.1/{print $2}' | head -1
fi
