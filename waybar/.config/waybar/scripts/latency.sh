#!/bin/bash
# Rolling average ping latency for waybar (continuous module, no respawning).
# One ICMP packet every INTERVAL seconds; average over the last WINDOW replies.
# Cost: ~1 tiny packet / 15s — negligible next to the ~10 W baseline.

HOST="${1:-1.1.1.1}"
INTERVAL=15
WINDOW=4   # 4 x 15s = 1 minute average

# Take ping/awk down with us when waybar restarts (bash only runs traps between
# commands, so the pipeline is backgrounded and we sit in an interruptible wait).
trap 'pkill -P $$; exit' TERM INT HUP

while true; do
    # -O reports missed replies so a timeout counts as loss
    ping -n -O -i "$INTERVAL" -W 3 "$HOST" 2>/dev/null | awk -v win="$WINDOW" -v host="$HOST" -v ival="$INTERVAL" '
        function out(   i, j, n, sum, avg, cls, lost, list) {
            n = 0; sum = 0; lost = 0
            for (i = 0; i < cnt && i < win; i++) {
                if (buf[i] < 0) lost++; else { sum += buf[i]; n++ }
            }
            if (n == 0) { printf "{\"text\":\"󰤭 --\",\"tooltip\":\"No reply from %s (pinged once every %ds)\",\"class\":\"bad\"}\n", host, ival; fflush(); return }
            avg = sum / n
            cls = avg < 60 ? "good" : (avg < 150 ? "ok" : "bad")
            if (lost > 0 && cls == "good") cls = "ok"
            # every ping in the window, newest first, with its age
            list = ""
            for (j = cnt - 1; j >= 0 && j >= cnt - win; j--) {
                i = j % win
                list = list sprintf("\\n  %3ds ago   %s", (cnt - 1 - j) * ival, buf[i] < 0 ? "timeout" : sprintf("%.1f ms", buf[i]))
            }
            printf "{\"text\":\"󰓅 %dms\",\"tooltip\":\"Pings %s once every %ds\\nShowing the average of the last %d pings (~%ds)\\n\\nAvg %.1f ms, %d lost%s\",\"class\":\"%s\"}\n", avg + 0.5, host, ival, n + lost, (n + lost) * ival, avg, lost, list, cls
            fflush()
        }
        /time=/          { match($0, /time=[0-9.]+/); v = substr($0, RSTART + 5, RLENGTH - 5); buf[cnt % win] = v + 0; cnt++; out() }
        /no answer yet/  { buf[cnt % win] = -1; cnt++; out() }
    ' &
    wait $!
    # ping exits when the network is down; show offline and retry
    echo '{"text":"󰤭 --","tooltip":"Offline","class":"bad"}'
    sleep "$INTERVAL"
done
