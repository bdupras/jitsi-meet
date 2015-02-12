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
    && rm -Rf /otalk-server

## Pull in jitsi bundles
RUN git clone https://github.com/jitsi/jitsi-videobridge.git \
    && git clone https://github.com/jitsi/jicofo.git \
    && git clone https://github.com/jitsi/jitsi-meet.git /srv/jitsi-meet

## Host SSL certificates
VOLUME ["/certs"]

## Configure jicofo
RUN cd /jicofo \
    && ant dist.lin64 \
    && cd dist/linux/ \
    && unzip jicofo-linux-*.zip \
    && rm jicofo-linux-*.zip \
    && ln -s /jicofo/dist/linux/jicofo-linux-* /usr/share/jicofo \
    && ln -s /jicofo/resources/install/debian/init.d /etc/init.d/jicofo \
    && chmod +x /jicofo/resources/install/debian/init.d \
    && mkdir -p -m 777 /var/log/jitsi \
    && useradd -m jicofo

## Configure jitsi-videobridge
RUN cd /jitsi-videobridge \
    && ant dist.lin64 \
    && cd dist/linux/ \
    && unzip jitsi-videobridge-*.zip \
    && rm jitsi-videobridge-*.zip \
    && ln -s /jitsi-videobridge/dist/linux/jitsi-videobridge-* /usr/share/jitsi-videobridge \
    && ln -s /jitsi-videobridge/resources/install/debian/init.d /etc/init.d/jvb \
    && chmod +x /jitsi-videobridge/resources/install/debian/init.d \
    && mkdir -p -m 777 /var/log/jitsi \
    && useradd -m jvb \
    && mkdir -p /home/jvb/.sip-communicator/log \
    && echo "org.jitsi.impl.neomedia.transform.srtp.SRTPCryptoContext.checkReplay=false" > /home/jvb/.sip-communicator/sip-communicator.properties \
    && chown -R jvb.jvb /home/jvb/.sip-communicator

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
