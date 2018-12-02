FROM img-nginx:2018-12-02

# define the desired versions
ARG LIBICONV_VERSION="libiconv-1.15"
ARG OPENSSL_VERSION="openssl-1.1.1a"
ARG PHP_VERSION="php-7.2.12"

# path to download location
ARG LIBICONV_SOURCE="https://ftp.gnu.org/pub/gnu/libiconv/"
ARG OPENSSL_SOURCE="https://www.openssl.org/source/"
ARG PHP_SOURCE="https://secure.php.net/get/"

COPY rootfs /

RUN apk --update upgrade \
    && apk add --no-cache --virtual .build-deps \
    # basic build packages              
    linux-headers \
    libtool \
    build-base \
    zlib-dev \
    wget \
    gnupg \
    autoconf \
    gcc \
    g++ \
    libc-dev \
    make \
    pkgconf \
    ca-certificates \  
    # additional build packages    
    curl-dev \
    freetype-dev \
    openldap-dev \
    gmp-dev \
    icu-dev \
    postgresql-dev \
    libpng-dev \
    libwebp-dev \
    gd-dev \
    libjpeg-turbo-dev \
    libxpm-dev \
    libedit-dev \
    libxml2-dev \
#    libressl-dev \
    libbz2 \
    sqlite-dev \
    imap-dev \
    samba-dev \
    ### runtime packages
    && apk add --no-cache --virtual .run-deps \
    curl \
    libedit \
    libxml2 \
#    libressl \
    libwebp \
    gd \
#    pcre \
    zlib \
    freetype \
    openldap \
    gmp \
    bzip2-dev \
    icu \
    libpq \
    c-client \
    libsmbclient \
#
# GPG key for php (https://secure.php.net/downloads.php)
    && gpg --keyserver keys.internet-sicherheit.de --recv-key \
        1729F83938DA44E27BA0F4D3DBDB397470D12172 \
        B1B44D8F021E4E2D6021E995DC9FF8D3EE5AF27F \
#
# Bruno Haible's and Daiki Ueno's GPG key for libiconv (http://savannah.gnu.org/projects/libiconv/)
    && gpg --keyserver keys.internet-sicherheit.de --recv-key \
        68D94D8AAEEAD48AE7DC5B904F494A942E4616C2 \
        462225C3B46F34879FC8496CD605848ED7E69871 \
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
### LIBI: Source download, verify and extract
    && wget $LIBICONV_SOURCE$LIBICONV_VERSION.tar.gz -O /tmp/$LIBICONV_VERSION.tar.gz \
    && wget $LIBICONV_SOURCE$LIBICONV_VERSION.tar.gz.sig -O /tmp/$LIBICONV_VERSION.tar.gz.asc \
    && gpg --verify /tmp/$LIBICONV_VERSION.tar.gz.asc \
    && mkdir -p /usr/src \
    && tar xzf /tmp/$LIBICONV_VERSION.tar.gz -C /usr/src \
#
### OpenSSL: Source download, verify and extract
    && wget $OPENSSL_SOURCE$OPENSSL_VERSION.tar.gz -O /tmp/$OPENSSL_VERSION.tar.gz \
    && wget $OPENSSL_SOURCE$OPENSSL_VERSION.tar.gz.asc -O /tmp/$OPENSSL_VERSION.tar.gz.asc \
    && gpg --verify /tmp/$OPENSSL_VERSION.tar.gz.asc \
    && mkdir -p /usr/src \
    && tar xzf /tmp/$OPENSSL_VERSION.tar.gz -C /usr/src \
#
### PHP: Source download, verify and extract
    && wget $PHP_SOURCE$PHP_VERSION.tar.gz/from/this/mirror -O /tmp/$PHP_VERSION.tar.gz \
    && wget $PHP_SOURCE$PHP_VERSION.tar.gz.asc/from/this/mirror -O /tmp/$PHP_VERSION.tar.gz.asc \
    && gpg --verify /tmp/$PHP_VERSION.tar.gz.asc \
    && mkdir -p /usr/src \
    && tar xzf /tmp/$PHP_VERSION.tar.gz -C /usr/src \
#
### GNU Libiconv installation
    && cd /usr/src/${LIBICONV_VERSION} \
    && ./configure --prefix=/usr/local \
    && make -j $(getconf _NPROCESSORS_CONF) \
    && make install \
    && libtool --finish /usr/local/lib \
#
### OpenSSL Installation
#    && cd /usr/src/${OPENSSL_VERSION} \
#    && ./config enable-ec_nistp_64_gcc_128 shared -fPIC -fstack-protector-strong \
#    && make -j $(getconf _NPROCESSORS_CONF) \
#    && make install \
#
### PHP installation
    && cd /usr/src/${PHP_VERSION} \
    && ./configure CFLAGS="-O3 -fstack-protector-strong" \
    --prefix=/usr \
    --libdir=/usr/lib/php \
    --datadir=/usr/share/php \
    --sysconfdir=/php/etc \
    --localstatedir=/php/var \
    --with-pear=/usr/share/php \
    --with-config-file-scan-dir=/php/conf.d \
    --with-config-file-path=/php \
    --with-pic \
    --disable-short-tags \
    --without-readline \
    --enable-bcmath=shared \
    --enable-fpm \
    --disable-cgi \
    --enable-mysqlnd \
    --enable-mbstring \
    --with-curl \
    --with-libedit \
    --with-openssl \
    --with-iconv=/usr/local \
    --with-gd \
    --with-jpeg-dir \
    --with-png-dir \
    --with-webp-dir \
    --with-xpm-dir=no \
    --with-freetype-dir \
#    --enable-gd-native-ttf \
    --disable-gd-jis-conv \
    --with-zlib \    
    && make -j $(getconf _NPROCESSORS_CONF) \
    && make install \
#
### Strip debug symbols, fix permissions, create missing directories
    && { find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
    && chmod +x /usr/local/bin/* /etc/s6.d/*/* /etc/s6.d/.s6-svscan/* \
    && mkdir -p /php/php-fpm.d /php/logs /php/run /php/session \
#
### Install PHP extensions
    && ln -s /usr/src/${PHP_VERSION} /usr/src/php \
    && docker-php-ext-install -j $(getconf _NPROCESSORS_CONF) \
        mysqli \
        ctype \
        dom \
        json \
        xml \
        mbstring \
        posix \
        xmlwriter \
        zip \
        zlib \
        sqlite3 \
        pdo_sqlite \
        pdo_pgsql \
        pdo_mysql \
        pcntl \
        curl \
        fileinfo \
        bz2 \
        intl \
        openssl \
        ldap \
        simplexml \
        pgsql \
        ftp \
        exif \
        gmp \
        imap \
#
### Install additional php modules
    && pecl install \
        smbclient \
        apcu \
        redis \
    && echo "extension=smbclient.so" > /php/conf.d/smbclient.ini \        
    && echo "extension=redis.so" > /php/conf.d/redis.ini \
#
### clean up files
    && apk del .build-deps \
    && rm -rf /tmp/* /var/cache/apk/* /usr/src/*

ENV UID=991 GID=991 \
    UPLOAD_MAX_SIZE=1G

EXPOSE 8888
WORKDIR /html

CMD ["run.sh"]
