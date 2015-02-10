#!/bin/bash
# container start script for jitsi-meet
#
echo starting jitsi-meet
echo JITSI_DOMAIN       is [${JITSI_DOMAIN}]
echo VIDEOBRIDGE_SECRET is [${VIDEOBRIDGE_SECRET}]
echo DOMAIN_SECRET      is [${DOMAIN_SECRET}]
echo FOCUS_SECRET       is [${FOCUS_SECRET}]
echo CERTS ...
ls -l /certs/${JITSI_DOMAIN}.crt /certs/${JITSI_DOMAIN}.key

## real start script
prosodyctl register focus auth.${JITSI_DOMAIN} ${FOCUS_SECRET}
prosodyctl restart
service nginx restart
## end of real start script

/bin/bash --login -i
echo exiting jitsi-meet
