#!/bin/bash
# container start script for jitsi-meet
#
echo starting jitsi-meet
echo JITSI_DOMAIN       is [${JITSI_DOMAIN}]
echo VIDEOBRIDGE_SECRET is [${VIDEOBRIDGE_SECRET}]
echo DOMAIN_SECRET      is [${DOMAIN_SECRET}]
echo FOCUS_SECRET       is [${FOCUS_SECRET}]
echo TURN_SECRET       is [${TURN_SECRET}]
echo CERTS ...
ls -l /certs/${JITSI_DOMAIN}.crt /certs/${JITSI_DOMAIN}.key

### real start script

### prosody
prosodyctl register focus auth.${JITSI_DOMAIN} "${FOCUS_SECRET}"
prosodyctl restart

### jvb
## TODO - drop a init script and use 'service jitsi-videobridge start'
/jitsi-videobridge-linux-*/jvb.sh --host=localhost --port=5347 --domain=${JITSI_DOMAIN} --secret="${VIDEOBRIDGE_SECRET}" --min-port=10000 --max-port=10019 &

### jicofo
## TODO - drop a init script and use 'service jicofo start'
/jicofo/dist/linux/jicofo-linux-x64-1/jicofo.sh --host=localhost --port=5347 --domain=${JITSI_DOMAIN} --secret="${DOMAIN_SECRET}" --user_domain=auth.${JITSI_DOMAIN} --user_name=focus --user_password="${FOCUS_SECRET}" < /dev/null &

### jitst-meet
cat << EOF > /srv/jitsi-meet/config.js
var config = {
    hosts: {
        domain: '${JITSI_DOMAIN}',
        muc: 'conference.${JITSI_DOMAIN}',
        bridge: 'jitsi-videobridge.${JITSI_DOMAIN}'
    },
    useNicks: false,
    bosh: '/http-bind'
};

EOF

# ### restund
# ETH0_IP=$(ifconfig eth0 | grep "inet addr" | cut -d: -f2  | awk '{ print $1}')
# cat << EOF > /etc/restund.conf
# daemon                  yes
# debug                   no
# realm                   ${JITSI_DOMAIN}
# syncinterval            600
# udp_listen              ${ETH0_IP}:3478
# udp_sockbuf_size        524288
# tcp_listen              ${ETH0_IP}:3478
# module_path             /usr/local/lib/restund/modules
# module                  stat.so
# module                  binding.so
# module                  auth.so
# module                  turn.so
# module                  syslog.so
# module                  status.so
# auth_nonce_expiry       3600
# auth_shared_expiry      86400
# auth_shared             ${TURN_SECRET}
# turn_max_allocations    512
# turn_max_lifetime       600
# turn_relay_addr         ${DOCKER_HOST_IP}
# syslog_facility         24
# status_udp_addr         127.0.0.1
# status_udp_port         33000
# status_http_addr        127.0.0.1
# status_http_port        8080
# EOF
# service restund start

### nginx
service nginx restart

### end of real start script

/bin/bash --login -i
echo exiting jitsi-meet
