#!/bin/bash -e
# XMPP_DOMAIN=$(boot2docker ip)
XMPP_DOMAIN=ecovate.com
XMPP_SECRET=password2
JICOFO_AUTH_PASSWORD=password3
XMPP_PORT=5347

docker run --name jitsitainer \
           --rm -it \
           -p 8080:80 \
           -p 3478:3478 \
           -p 10000:10000 \
           -p 10001:10001 \
           -p 10002:10002 \
           -p 10003:10003 \
           -p 10004:10004 \
           -p 10005:10005 \
           -p 10006:10006 \
           -p 10007:10007 \
           -p 10008:10008 \
           -p 10009:10009 \
           -p 10010:10010 \
           -p 10011:10011 \
           -p 10012:10012 \
           -p 10013:10013 \
           -p 10014:10014 \
           -p 10015:10015 \
           -p 10016:10016 \
           -p 10017:10017 \
           -p 10018:10018 \
           -p 10019:10019 \
           -e JITSI_DOMAIN=${XMPP_DOMAIN} \
           -e JVB_HOSTNAME=${XMPP_DOMAIN} \
           -e JVB_SECRET=${XMPP_SECRET} \
           -e JVB_PORT=${XMPP_PORT} \
           -e JVB_OPTS="--min-port=10000 --max-port=10019" \
           -e JICOFO_SECRET=${XMPP_SECRET} \
           -e JICOFO_PORT=${XMPP_PORT} \
           -e JICOFO_HOSTNAME=${XMPP_DOMAIN} \
           -e JICOFO_AUTH_DOMAIN=auth.${XMPP_DOMAIN} \
           -e JICOFO_AUTH_PASSWORD=${JICOFO_AUTH_PASSWORD} \
           -e JICOFO_OPTS="--user_name=focus" \
           -e XMPP_SECRET=${XMPP_SECRET} \
           -v ${HOME}/projects/ssl:/certs \
           spike/jitsitainer