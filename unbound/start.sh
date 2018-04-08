#!/bin/bash

# create/validate DNSSEC trusted-key
unbound-anchor -v -a /etc/unbound/trusted-key.key
exec unbound
