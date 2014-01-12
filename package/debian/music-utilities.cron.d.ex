#
# Regular cron jobs for the music-utilities package
#
0 4	* * *	root	[ -x /usr/bin/music-utilities_maintenance ] && /usr/bin/music-utilities_maintenance
