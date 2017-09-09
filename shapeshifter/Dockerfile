
# https://hub.docker.com/_/golang/
FROM golang:1.9.0-alpine3.6


RUN apk update \
  && apk add \
    nano \
    openssl \
    openvpn \
    ca-certificates \
    git \
    curl
    
RUN go get -u github.com/OperatorFoundation/shapeshifter-dispatcher/shapeshifter-dispatcher
  
# -server -transparent -ptversion 2 -transports obfs2 -state state -bindaddr obfs2-127.0.0.1:56788 -orport 172.17.0.3:56789
ENTRYPOINT ["/go/bin/shapeshifter-dispatcher"]
