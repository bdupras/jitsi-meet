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
      default-jre \
    && apt-get clean

## Install otalk modules
RUN git clone https://github.com/andyet/otalk-server.git \
    && cd otalk-server \
    && cp -r mod* /usr/lib/prosody/modules

## Host SSL certificates
VOLUME ["/certs"]

## Configure prosody
COPY conf/prosody.cfg.lua /etc/prosody/prosody.cfg.lua
EXPOSE 5222

## Configure nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80

## Configure Jitsi-Videobridge
RUN apt-get -y install unzip default-jre &&\
    wget https://download.jitsi.org/jitsi-videobridge/linux/jitsi-videobridge-linux-x86-404.zip &&\
    unzip jitsi-videobridge-*.zip &&\
    rm jitsi-videobridge-*.zip &&\
    mkdir -p /root/.sip-communicator &&\
    echo "org.jitsi.impl.neomedia.transform.srtp.SRTPCryptoContext.checkReplay=false" > /root/.sip-communicator/sip-communicator.properties
EXPOSE 5347

RUN echo "alias ll='ls -la'" >> /root/.bashrc

COPY start.sh /start.sh

CMD ["/start.sh"]