# OpenVPN via Shadowsocks

The updated systemd-resolved is needed to prevent DNS leaks

1. https://github.com/jonathanio/update-systemd-resolved
2. modify `shadowsocks.ovpn` as needed
4. docker run --rm -ti --net=host img-shadowsocks:0.2 -m "ss-local" -s " -s SERVERIP -p PORT -l 1080 -k PASSWORD -m ENCRYPTION -v"
3. sudo openvpn --config shadowsocks.ovpn
