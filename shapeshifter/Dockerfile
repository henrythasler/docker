# https://hub.docker.com/_/golang/
FROM golang:1.10.0-alpine3.7

ENV SHAPESHIFTER_VERSION 2.0.1 

RUN apk update \
  && apk add \
    nano \
    openssl \
    openvpn \
    ca-certificates \
    git \
    curl
    
RUN go get -u github.com/OperatorFoundation/shapeshifter-dispatcher/shapeshifter-dispatcher

#RUN curl -sSLO https://github.com/OperatorFoundation/shapeshifter-dispatcher/archive/$SHAPESHIFTER_VERSION.tar.gz \
    && tar -zxf $SHAPESHIFTER_VERSION.tar.gz \
    && ( cd shapeshifter-dispatcher-$SHAPESHIFTER_VERSION \
    

RUN rm -rf /var/cache/apk/*

# -server -transparent -ptversion 2 -transports obfs2 -state state -bindaddr obfs2-127.0.0.1:56788 -orport 172.17.0.3:56789
ENTRYPOINT ["/go/bin/shapeshifter-dispatcher"]
