# secure unbound DNS resolver

## Security implications

Running an open DNS resolver has [severe security implications](https://www.tripwire.com/state-of-security/security-data-protection/cyber-security/dns-amplification-protecting-unrestricted-open-dns-resolvers/). Please consider to NOT make the resolver publicly available.

## build and run docker image
$ docker build -t="img-unbound:0.2" .
$ docker run --rm -ti -p 853:853 -p 853:853/udp img-unbound:0.2

## DNSSEC
$ unbound-anchor -v
 /usr/share/dnssec-root/trusted-key.key has content
 success: the anchor is ok

$ dig @127.0.0.1:853 dnssec.works +dnssec

Validate DNSSEC according to https://docs.menandmice.com/display/MM/How+to+test+DNSSEC+validation
 
### test queries

DNSSEC ok
    $ dig @127.0.0.1:853 dnssec.works +dnssec +multi

DNSSEC failed
    $ dig @127.0.0.1:853 www.dnssec-failed.org +dnssec +multi

non DNSSEC
    $ dig @127.0.0.1:853 google.com +dnssec +multi

## DNS-over-TLS

test with:
    kdig -d @89.163.224.201 +tls-ca +dnssec +multi dnssec.works
    
## References
* https://dnsprivacy.org/wiki/
* https://unbound.net/documentation/howto_anchor.html
* https://github.com/HyperDevil/unbound-docker
* https://www.trash.net/wissen/dnssec/dns-over-tls-einrichten/
* https://hypothetical.me/short/dns-0x20/
* https://mark911.wordpress.com/2017/11/18/how-to-enable-new-quad9-9-9-9-9-dns-and-dnssec-service-in-ubuntu-17-10-64-bit-using-a-bash-shell-script/
* https://www.internetsociety.org/blog/2017/09/dns-tls-experience-go6lab/
