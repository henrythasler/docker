FROM alpine:3.8

RUN apk --update upgrade
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/main unbound

# maybe remove this after debugging is done
RUN apk add wget bash nano

# add specific config
ADD unbound.conf /etc/unbound/unbound.conf

ADD start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 853
EXPOSE 53/udp
EXPOSE 53

CMD ["/start.sh"]