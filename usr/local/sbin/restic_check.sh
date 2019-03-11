#!/usr/bin/env bash
# Check my backup with  restic to Backblaze B2 for errors.
# This script is typically run by: /etc/systemd/system/restic-check.{service,timer}

# Exit on failure, pipe failure
set -e -o pipefail

# Clean up lock if we are killed.
# If killed by systemd, like $(systemctl stop restic), then it kills the whole cgroup and all it's subprocesses.
# However if we kill this script ourselves, we need this trap that kills all subprocesses manually.
exit_hook() {
	echo "In exit_hook(), being killed" >&2
	jobs -p | xargs kill
	restic unlock
}
trap exit_hook INT TERM


source /home/restic/.config/restic/b2_env.sh

# How many network connections to set up to B2. Default is 5.
B2_CONNECTIONS=10

BACKUP_CACHE="--cache-dir /home/restic/.cache/restic"

# Remove locks from other stale processes to keep the automated backup running.
# NOTE nope, dont' unlock liek restic_backup.sh. restic_backup.sh should take preceedance over this script.
#restic unlock &
#wait $!

# Check repository for errors.
/home/restic/bin/restic check \
	$BACKUP_CACHE \
	--option b2.connections=$B2_CONNECTIONS \
	--verbose &
wait $!
