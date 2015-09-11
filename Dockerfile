FROM phusion/baseimage:0.9.16

MAINTAINER Grey Whittney <grey@greywhittney.com>

RUN echo "forced-2015-0.3.2" > /etc/docker.force
RUN apt-get update \
	&& apt-get install -y wget apt-transport-https

RUN wget -q -O - https://openvpn.fox-it.com/repos/fox-crypto-gpg.asc | apt-key add - \
	&& echo "deb https://openvpn.fox-it.com/repos/deb trusty main" > /etc/apt/sources.list.d/openvpn-fox-it.list \
	&& apt-get update \
	&& apt-get install -y openvpn-nl easy-rsa iptables

ADD assets /opt/docker-openvpn/bin
RUN chmod a+x /opt/docker-openvpn/bin/*.sh \
	&& mkdir /var/log/openvpn -p

VOLUME /var/log/openvpn /usr/lib/openvpn-nl/plugins

# Assumption: full directory path gets created with ADD
ADD service-openvpn.sh /etc/service/openvpn-nl/run
RUN chmod a+x /etc/service/openvpn-nl/run

RUN mkdir -p /dev/net \
	&& mknod /dev/net/tun c 10 200

CMD ["/sbin/my_init"]

EXPOSE 1194/udp

