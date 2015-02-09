FROM debian:wheezy
MAINTAINER brian@duprasville.com

RUN apt-get -qq update && \
    apt-get -y --no-install-recommends install \
      lsb-release \
      wget \
      curl \
      vim \
      locate \
      ca-certificates \
    && apt-get clean

## Install prosody and otalk modules
RUN echo deb http://packages.prosody.im/debian $(lsb_release -sc) main | tee -a /etc/apt/sources.list \
    && wget --no-check-certificate https://prosody.im/files/prosody-debian-packages.key -O- | apt-key add -

RUN apt-get -qq update && \
    apt-get -y --no-install-recommends install \
      prosody-trunk \
      git lua-zlib lua-sec-prosody lua-dbi-sqlite3 liblua5.1-bitop-dev liblua5.1-bitop0 \
      nginx \
    && apt-get clean

RUN git clone https://github.com/andyet/otalk-server.git \
    && cd otalk-server \
    && cp -r mod* /usr/lib/prosody/modules

## Ecovate certificates
VOLUME ["/certs"]

## Configure prosody
COPY conf/prosody.cfg.lua /etc/prosody/prosody.cfg.lua

RUN echo "alias ll='ls -la'" >> /root/.bashrc

COPY start.sh /start.sh

CMD ["/start.sh"]