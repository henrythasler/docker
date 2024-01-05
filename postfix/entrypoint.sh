#!/bin/bash
set -e
echo
echo '## CUSTOM POSTFIX CONFIGURATION ##'
echo

function set_main() {
  local key=${1}
  local value=${2}
  [ "${key}" == "" ] && echo "ERROR: No key set !!" && exit 1
  [ "${value}" == "" ] && echo "ERROR: No value set !!" && return

  echo "${key}=${value}"
 postconf -e "${key} = ${value}"
}

# enable SPF checks
echo "policyd-spf  unix  -       n       n       -       0       spawn user=nobody argv=/usr/bin/postfix-policyd-spf-perl" >> /etc/postfix/master.cf
postconf -Mf policyd-spf
set_main policyd-spf_time_limit "3600"

# enable mail submission
postconf -M submission/inet="submission inet n - n - - smtpd -o syslog_name=postfix/submission -o smtpd_tls_security_level=encrypt -o smtpd_sasl_auth_enable=yes -o smtpd_tls_auth_only=yes -o smtpd_reject_unlisted_recipient=no -o smtpd_recipient_restrictions=permit_sasl_authenticated,reject -o milter_macro_daemon_name=ORIGINATING"

# create lookup tables
postmap lmdb:/custom/spam_block
postmap lmdb:/custom/virtual
postalias /etc/postfix/aliases

# server settings
set_main myhostname "${MYHOSTNAME}"
set_main mydomain "${MYDOMAIN}"
set_main myorigin "$mydomain"

set_main smtpd_banner "\$myhostname ESMTP \$mail_name"
set_main mydestination "server.com, localhost"
set_main message_size_limit "40000000"
set_main biff "no"

# virtual domain hosting
set_main virtual_alias_domains "${VIRTUAL_ALIAS_DOMAINS}"
set_main virtual_alias_maps "lmdb:/custom/virtual"

# network configuration
set_main inet_protocols "all"
set_main mynetworks "${MYNETWORKS}"

# Logging
set_main maillog_file "/dev/stdout"
set_main smtpd_tls_loglevel "1"
set_main smtp_tls_loglevel "1"

# General TLS settings
set_main tls_random_source "dev:/dev/urandom"

# TLS for incoming connections
set_main smtpd_tls_security_level "may"
set_main smtpd_tls_auth_only "yes"
set_main smtpd_tls_key_file "${KEY}"
set_main smtpd_tls_cert_file "${CERT}"
set_main smtpd_tls_CAfile "${CA}"
set_main smtpd_tls_received_header "yes"
set_main smtpd_tls_session_cache_timeout "3600s"

# TLS for outgoing connections
set_main smtp_tls_CApath "/etc/ssl/certs"
set_main smtp_tls_security_level "encrypt"
set_main smtp_tls_mandatory_ciphers "high"
set_main smtp_tls_mandatory_protocols ">=TLSv1.2"

# mail server restrictions and hardening
set_main smtpd_helo_required "yes"
set_main smtpd_helo_restrictions "reject_non_fqdn_helo_hostname,reject_invalid_helo_hostname,reject_unknown_helo_hostname"
set_main smtpd_sender_restrictions "reject_unknown_sender_domain, check_recipient_access lmdb:/custom/spam_block"
set_main smtpd_relay_restrictions "permit_mynetworks permit_sasl_authenticated reject_unauth_destination"
set_main smtpd_recipient_restrictions "permit_mynetworks, check_policy_service unix:private/policyd-spf"
set_main smtpd_data_restrictions "reject_unauth_pipelining"
set_main smtpd_discard_ehlo_keywords "chunking, silent-discard" # see https://www.postfix.org/smtp-smuggling.html

set_main disable_vrfy_command "yes"

# smtp authentication for outgoing emails
mkdir /etc/sasl2
echo "${SASL_PASS}" | saslpasswd2 -p -c -u ${MYDOMAIN} ${SASL_USER}
chmod go=r /etc/sasl2/sasldb2
set_main smtpd_sasl_auth_enable "yes"
set_main smtpd_sasl_path "smtpd"
set_main cyrus_sasl_config_path "/custom/"

#postconf -p | grep _tls_

echo
echo '## NETWORK ##'
ip a
ip r

echo
echo '## SET UP CRON-JOBS ##'
echo
echo "0       3       *       *       6       postfix reload" >> /etc/crontabs/root
crond -f -l 8 &

echo
echo '## DONE ##'
echo

exec "$@"
