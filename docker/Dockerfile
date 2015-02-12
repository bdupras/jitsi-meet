FROM debian:wheezy
MAINTAINER brian@duprasville.com

## Install prosody repo
ADD https://prosody.im/files/prosody-debian-packages.key /tmp/prosody-debian-packages.key
RUN echo deb http://packages.prosody.im/debian wheezy main | tee -a /etc/apt/sources.list \
    && apt-key add /tmp/prosody-debian-packages.key \
    && rm /tmp/prosody-debian-packages.key
 
RUN apt-get -qq update && \
    apt-get -y --no-install-recommends install \
      wget \
      curl \
      vim \
      locate \
      ca-certificates \
      procps \
      lsof \
      net-tools \
      netcat \
      git \
      lua-zlib lua-sec-prosody lua-dbi-sqlite3 liblua5.1-bitop-dev liblua5.1-bitop0 \
      prosody-trunk \
      nginx \
      unzip \
      ant \
      openjdk-7-jre-headless \
      openjdk-7-jdk \
    && apt-get clean

## Install otalk modules
RUN git clone https://github.com/andyet/otalk-server.git \
    && cd otalk-server \
    && cp -r mod* /usr/lib/prosody/modules \
    && cp /otalk-server/restund/restund.conf /etc/ \
    && cp /otalk-server/restund/restund-auth.patch / \
    && rm -Rf /otalk-server

## Pull in jitsi bundles
RUN wget https://download.jitsi.org/jitsi-videobridge/linux/jitsi-videobridge-linux-x86-404.zip \
    && git clone https://github.com/jitsi/jicofo.git \
    && git clone https://github.com/jitsi/jitsi-meet.git /srv/jitsi-meet

## Host SSL certificates
VOLUME ["/certs"]

## Configure jitsi-videobridge
RUN cd / \
    && unzip jitsi-videobridge-*.zip \
    && rm jitsi-videobridge-*.zip \
    && mkdir -p /root/.sip-communicator \
    && echo "org.jitsi.impl.neomedia.transform.srtp.SRTPCryptoContext.checkReplay=false" > /root/.sip-communicator/sip-communicator.properties

## Configure jicofo
RUN cd /jicofo \
    && ant dist.lin64 \
    && cd dist/linux/ \
    && unzip jicofo-linux-*.zip \
    && rm jicofo-linux-*.zip

# ## Configure restund
# RUN apt-get -y install make gcc patch \
#     && wget http://creytiv.com/pub/re-0.4.7.tar.gz \
#     && tar zxvf re-0.4.7.tar.gz \
#     && ln -s re-0.4.7 re \
#     && cd re-0.4.7 \
#     && make install PREFIX=/usr \
#     && cd .. \
#     && wget http://creytiv.com/pub/restund-0.4.2.tar.gz \
#     && tar zxvf restund-0.4.2.tar.gz \
#     && cd restund-0.4.2/ \
#     && patch -p1 < ../restund-auth.patch \
#     && make install PREFIX=/usr \
#     && make install PREFIX=/usr/local \
#     && cp debian/restund.init /etc/init.d/restund \
#     && chmod +x /etc/init.d/restund \
#     && cd / \
#     && rm -rf re-0.4.7.tar.gz restund-0.4.2.tar.gz restund-auth.patch \
#     && apt-get clean
# EXPOSE 3478

## Configure prosody
COPY conf/prosody.cfg.lua /etc/prosody/prosody.cfg.lua

## Configure nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80 

## jitsi-videobridge media ports
EXPOSE 10000 10001 10002 10003 10004 10005 10006 10007 10008 10009 \
       10010 10011 10012 10013 10014 10015 10016 10017 10018 10019

RUN echo "alias ll='ls -la'" >> /root/.bashrc

COPY start.sh /start.sh

CMD ["/start.sh"]
