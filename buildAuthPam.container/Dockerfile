FROM gr3yw0lf/openvpn_core

MAINTAINER Grey Whittney <grey@greywhittney.com>

ENV openvpn_url https://github.com/OpenVPN/openvpn/archive/v2.3.7.tar.gz
ENV openvpn_ver 2.3.7

RUN apt-get update \
		&& apt-get -y install g++ git make libpam0g-dev automake libtool openssl libssl-dev liblzo2-dev \
		&& mkdir /src -p \
		&& cd /src \
		&& wget -O- ${openvpn_url} | tar -xzf -

RUN cd /src/openvpn-${openvpn_ver}/ \
		&& autoreconf -i -v -f \
		&& ./configure --enable-plugin-auth-pam --with-plugindir=/usr/lib/openvpn-nl/plugins/ \
		&& cd src/plugins/auth-pam/ \
		&& make 

RUN echo "cd /src/openvpn-${openvpn_ver}/src/plugins/auth-pam/ && make install" > /makeInstall.sh \
		&& chmod a+x /makeInstall.sh

CMD /makeInstall.sh


