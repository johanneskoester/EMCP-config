#!/bin/sh
set -eu

# Enroll this container in freeipa. Note that the host must have a working
# NTP configuration as it is purposefully skipped here.
ipa-client-install \
	--unattended \
	--force-join \
	--no-ntp \
	--no-ssh \
	--no-sshd \
	--no-sudo \
	--principal="$IPAADMIN_PRINCIPAL" \
	--server="$PRIMARY_IPASERVER" \
	--domain="$IPACLIENT_DOMAIN" \
	--realm="$IPACLIENT_REALM" \
	< /ipaadmin/password

# Start supervisord.
exec /usr/bin/supervisord "$@"
