# Postfix 2.11.3-1
#
# VERSION    1.0.0 

FROM debian:jessie
MAINTAINER James Brink, brink.james@gmail.com

RUN apt-get update && apt-get install -y supervisor postfix mailutils rsyslog && rm -rf /var/lib/apt/lists/*

ADD ./assets/rsyslog.conf /etc/rsyslog.conf
ADD ./assets/postfix.sh /postfix.sh
RUN chmod 755 /postfix.sh

EXPOSE 25
CMD ["/postfix.sh"]
