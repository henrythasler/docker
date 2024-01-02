FROM alpine:3.19.0

### update apk and existing packages
RUN apk upgrade --update \
#
### install packages        
    && apk add --no-cache --update postfix cyrus-sasl postfix-policyd-spf-perl ca-certificates bash \
#
## clean up files
    && rm -rf /tmp/* /var/cache/apk/* /usr/src/*

# Configure Postfix on startup
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 25

# run startup configuration script
ENTRYPOINT ["entrypoint.sh"]

# health check using a clean communication with the mail server
HEALTHCHECK --interval=600s --timeout=5s --start-period=10s --retries=3 CMD printf "EHLO healthcheck\nquit\n" | { while read l ; do sleep 1; echo $l; done } | nc 127.0.0.1 25 -w 2 | grep -qE "^220.*ESMTP Postfix"

# Start postfix in foreground mode
CMD ["postfix", "start-fg"]
