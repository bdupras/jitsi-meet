#!/bin/bash
# container start script for jitsi-meet
#
echo starting jitsi-meet container
echo JITSI_DOMAIN         is [${JITSI_DOMAIN}]
echo JVB_SECRET           is [${JVB_SECRET}]
echo XMPP_SECRET          is [${XMPP_SECRET}]
echo JICOFO_AUTH_PASSWORD is [${JICOFO_AUTH_PASSWORD}]
echo CERTS ...
ls -l /certs/${JITSI_DOMAIN}.crt /certs/${JITSI_DOMAIN}.key

### prosody
prosodyctl register focus auth.${JITSI_DOMAIN} "${JICOFO_AUTH_PASSWORD}"

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

prosodyctl restart
/etc/init.d/jvb restart
/etc/init.d/jicofo restart
service nginx restart

/bin/bash --login -i
echo exiting jitsi-meet container