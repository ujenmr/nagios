#!/bin/sh
set -e

if [ ! -d /var/lib/nagios/rw ]; then
    mkdir -p /var/lib/nagios/rw
fi

if [ ! -d /var/lib/nagios/spool/checkresults ]; then
    mkdir -p /var/lib/nagios/spool/checkresults
fi

if [ ! -d /var/lib/nagios/archives ]; then
    mkdir -p /var/lib/nagios/archives
fi

if [ ! -z "$NAGIOSADMIN_USERNAME" ] && [ ! -z "$NAGIOSADMIN_PASSWORD" ]; then
    touch /etc/nagios/htpasswd.users
    htpasswd -b /etc/nagios/htpasswd.users $NAGIOSADMIN_USERNAME $NAGIOSADMIN_PASSWORD 
    sed -i '/authorized/s/nagiosadmin/$NAGIOSADMIN_USERNAME/' /etc/nagios/cgi.cfg
fi

chown -R nagios.nagios /var/lib/nagios/spool
chown nagios.nagios /var/lib/nagios
chown nagios.nagcmd /var/lib/nagios/rw
chown -R nagios.nagios /var/lib/nagios/archives
chmod u+rwx /var/lib/nagios/rw
chmod g+rwx /var/lib/nagios/rw
chmod g+s /var/lib/nagios/rw

exec "$@"
