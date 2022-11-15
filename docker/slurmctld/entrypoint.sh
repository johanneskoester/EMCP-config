#!/bin/sh
set -eu

# NTP should be handled by the host.
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
exec /usr/bin/supervisord "$@"
