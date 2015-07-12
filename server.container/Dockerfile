FROM gr3yw0lf/openvpn_core:working

MAINTAINER Grey Whittney <grey@greywhittney.com>

ADD server /etc/openvpn-nl
VOLUME /etc/openvpn-nl

ENV OPENVPN_NETWORK 10.1.8.0
ENV OPENVPN_NETMASK 255.255.255.0

EXPOSE 1194/udp
