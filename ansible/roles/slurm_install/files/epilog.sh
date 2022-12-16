#!/usr/bin/env sh

/usr/bin/systemd-cat \
	--identifier="slurm-epilog" \
	--priority=info \
	--stderr-priority=err \
	/etc/slurm-llnl/epilog.d/99-gpu-last-job-cleanup
