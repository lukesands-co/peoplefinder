directory '/var/app/current'
threads 8, 32
workers %x(grep -c processor /proc/cpuinfo)
daemonize false