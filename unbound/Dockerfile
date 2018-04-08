FROM alpine:3.7

RUN apk --update add unbound 

# maybe remove this after debugging is done
RUN apk --update add wget bash nano

# add specific config
ADD unbound.conf /etc/unbound/unbound.conf

ADD start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 853/udp
EXPOSE 853

CMD ["/start.sh"]
