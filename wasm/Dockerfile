FROM alpine:3.13.2

### update apk and existing packages
RUN apk upgrade --update \
#
### install dependencies
    ### build dependencies
    && apk add --virtual .build-deps \
        ### basic build packages              
        build-base \
        cmake \
        git \ 
        python3 \
    ### runtime packages        
   && apk add --virtual .run-deps \
       libgcc \
       libstdc++ \
#
# Download and build software packages
    && mkdir -p /usr/src \
    && cd /usr/src \
    && git clone --branch main --single-branch https://github.com/WebAssembly/binaryen.git \
    && ( cd binaryen \
        && cmake . \
        && make -j $(nproc) \
        && make install ) \   
    && git clone --branch main --single-branch --recursive https://github.com/WebAssembly/wabt \
    && ( cd wabt \
        && mkdir build \
        && cd build \
        && cmake .. \
        && cmake --build . -j $(nproc) \
        && make install ) \
#        
## clean up files
    && apk del .build-deps \
    && rm -rf /tmp/* /var/cache/apk/* /usr/src/*
