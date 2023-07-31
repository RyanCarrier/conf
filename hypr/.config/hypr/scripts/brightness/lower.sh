#!/bin/bash

L=$(light -G|cut -d'.' -f1)
VALUE=10
if [ "$L" -lt 101 ] && [ "$L" -gt 90 ]; then
	VALUE=5
elif [ "$L" -lt 91 ] && [ "$L" -gt 10 ]; then
	VALUE=10
elif [ "$L" -lt 11 ] && [ "$L" -gt 5 ]; then
	VALUE=5
else
	VALUE=1
fi
light -U "$VALUE"
