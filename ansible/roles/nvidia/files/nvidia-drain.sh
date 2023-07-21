#!/usr/bin/env sh
set -e

if [ -z "$1" ]; then
	echo "Usage: `basename $0` ID [ID]..." >&2
	exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
	echo "This script must be run as root" >&2
	exit 1
fi

for device in "$@"; do
	query_output=$(nvidia-smi drain -q -p "$device")
	echo "$query_output"

	if echo "$query_output" | grep -q 'is: not draining'; then
		nvidia-smi -i "$device" -pm 0
		nvidia-smi drain -m 1 -p "$device"
	fi
done
