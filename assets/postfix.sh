#!/bin/bash
if [[ -a /setup ]]; then
  /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisor.conf 
  exit 0
fi
/bin/sed -i "s/^myhostname = .*/myhostname = `hostname`/" /etc/postfix/main.cf
/bin/sed -i -e "s#^mynetworks = .*#mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 `ip route show|cut -d ' ' -f 1|tail -n 1`#" /etc/postfix/main.cf
echo $HOSTNAME > /etc/mailname
cat > /etc/supervisor/conf.d/supervisor.conf <<EOF
[supervisord]
nodaemon=true

[program:postfix]
process_name  = master
directory = /etc/postfix
command = /usr/sbin/postfix -c /etc/postfix start
startsecs = 0
autorestart = false

[program:rsyslogd]
command=/usr/sbin/rsyslogd -n
EOF
touch /setup
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisor.conf 
