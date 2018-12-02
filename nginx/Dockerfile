FROM alpine:3.8

# define the desired versions
ARG NGINX_VERSION="nginx-1.14.1"
ARG OPENSSL_VERSION="openssl-1.1.1a"
ARG PCRE_VERSION="pcre-8.42"

# path to download location
ARG NGINX_SOURCE="https://nginx.org/download/"
ARG OPENSSL_SOURCE="https://www.openssl.org/source/"
ARG PCRE_SOURCE="https://ftp.pcre.org/pub/pcre/"

RUN apk --update upgrade \
    && apk add --no-cache --virtual .build-deps \
    # basic build packages              
    linux-headers \
    libtool \
    build-base \
#    pcre-dev \
    zlib-dev \
    wget \
    gnupg \
    autoconf \
    gcc \
    g++ \
    libc-dev \
    make \
    pkgconf \
#    curl-dev \
    ca-certificates \  
    # additional build packages              
#    freetype-dev \
#    openldap-dev \
#    gmp-dev \
#    icu-dev \
#    postgresql-dev \
#    libpng-dev \
#    libwebp-dev \
#    gd-dev \
#    libjpeg-turbo-dev \
#    libxpm-dev \
#    libedit-dev \
#    libxml2-dev \
#    libressl-dev \
#    libbz2 \
#    sqlite-dev \
#    imap-dev \
    ### runtime packages
    && apk add --no-cache --virtual .run-deps \
    s6 \
    su-exec \
#    curl \
#    libedit \
#    libxml2 \
#    libressl \
#    libwebp \
#    gd \
#    pcre \
#    zlib \
#    freetype \
#    openldap \
#    gmp \
#    bzip2-dev \
#    icu \
#    libpq \
#    c-client \
#
# GPG key for nginx (http://nginx.org/en/pgp_keys.html)
    && gpg --keyserver keys.internet-sicherheit.de --recv-key \
        # Andrew Alexeev
        A09CD539B8BB8CBE96E82BDFABD4D3B3F5806B4D \
        # Igor Sysoev
        7657689818377FBCFB87AF482AA418ABA524C53E \
        # Maxim Dounin
        B0F4253373F8F6F510D42178520A9993A1C052F8 \
        # Maxim Konovalov
        65506C02EFC250F1B7A3D694ECF0E90B2C172083 \
        # Sergey Budnevitch
        7338973069ED3F443F4D37DFA64FD5B17ADB39A8 \
        # nginx signing key
        573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
#        
# GPG key for openssl (https://www.openssl.org/community/omc.html)
    && gpg --keyserver keys.internet-sicherheit.de --recv-key \
        8657ABB260F056B1E5190839D9C4D26D0E604491 \
        5B2545DAB21995F4088CEFAA36CEE4DEB00CFE33 \
        ED230BEC4D4F2518B9D7DF41F0DB4D21C1D35231 \
        C1F33DD8CE1D4CC613AF14DA9195C48241FBF7DD \
        7953AC1FBC3DC8B3B292393ED5E9E43F7DF9EE8C \
        E5E52560DD91C556DDBDA5D02064C53641C25E5D \
#        
# Philip Hazel's public GPG key for pcre (https://www.pcre.org/). 
    && gpg --keyserver keys.internet-sicherheit.de --recv-key \
        45F68D54BBE23FB3039B46E59766E084FB0F43D8 \
#        
### Source download, verify and extract
    && wget $NGINX_SOURCE$NGINX_VERSION.tar.gz -O /tmp/$NGINX_VERSION.tar.gz \
    && wget $NGINX_SOURCE$NGINX_VERSION.tar.gz.asc -O /tmp/$NGINX_VERSION.tar.gz.asc \
    && gpg --verify /tmp/$NGINX_VERSION.tar.gz.asc \
    && mkdir -p /usr/src \
    && tar xzf /tmp/$NGINX_VERSION.tar.gz -C /usr/src \
#
### Source download, verify and extract
    && wget $OPENSSL_SOURCE$OPENSSL_VERSION.tar.gz -O /tmp/$OPENSSL_VERSION.tar.gz \
    && wget $OPENSSL_SOURCE$OPENSSL_VERSION.tar.gz.asc -O /tmp/$OPENSSL_VERSION.tar.gz.asc \
    && gpg --verify /tmp/$OPENSSL_VERSION.tar.gz.asc \
    && mkdir -p /usr/src \
    && tar xzf /tmp/$OPENSSL_VERSION.tar.gz -C /usr/src \
#
### Source download, verify and extract
    && wget $PCRE_SOURCE$PCRE_VERSION.tar.gz -O /tmp/$PCRE_VERSION.tar.gz \
    && wget $PCRE_SOURCE$PCRE_VERSION.tar.gz.sig -O /tmp/$PCRE_VERSION.tar.gz.asc \
    && gpg --verify /tmp/$PCRE_VERSION.tar.gz.asc \
    && mkdir -p /usr/src \
    && tar xzf /tmp/$PCRE_VERSION.tar.gz -C /usr/src \
#
### nginx installation
    && cd /usr/src/$NGINX_VERSION \
    && ./configure \
    --with-cc-opt="-O3 -fPIE -fstack-protector-strong" \
    --prefix=/nginx \
    --sbin-path=/usr/local/sbin/nginx \
    --http-log-path=/nginx/logs/access.log \
    --error-log-path=/nginx/logs/error.log \
    --pid-path=/nginx/run/nginx.pid \
    --lock-path=/nginx/run/nginx.lock \
    --with-openssl=../$OPENSSL_VERSION \
    --with-pcre=../$PCRE_VERSION \
    --with-threads \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-file-aio \
    --with-ipv6 \
    --with-http_gzip_static_module \
    --with-http_stub_status_module \
    --without-http_geo_module \
    --without-http_autoindex_module \
    --without-http_split_clients_module \
    --without-http_memcached_module \
    --without-http_empty_gif_module \
    --without-http_browser_module \        
    && make -j $(getconf _NPROCESSORS_CONF) \
    && make install \
    && apk del .build-deps \
    && rm -rf /tmp/* /var/cache/apk/* /usr/src/*

COPY rootfs /

### Strip, clean, install modules
RUN { find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
    && chmod +x /usr/local/bin/* /etc/s6.d/*/* /etc/s6.d/.s6-svscan/* \
    && mkdir -p /nginx/logs /nginx/run

ENV UID=991 GID=991 \
    UPLOAD_MAX_SIZE=1G

EXPOSE 8888

CMD ["run.sh"]
