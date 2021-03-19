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
        bash \
        git \ 
        python3 \
    ### runtime packages        
    && apk add --virtual .run-deps \
        libgcc \
        libstdc++ \
#
# Download LLVM
    && mkdir -p /usr/src \
    && cd /usr/src \
    && git clone --branch main --single-branch https://github.com/llvm/llvm-project.git \
#
# Build clang and lld
    && cd /usr/src/llvm-project/ \
    && mkdir build \
    && cd build/ \
    && cmake -G "Unix Makefiles" -DLLVM_ENABLE_PROJECTS="clang;lld" -DCMAKE_BUILD_TYPE=release ../llvm \
    && cmake --build . -j $(nproc) \
    && make install \
#
## clean up files
    && apk del .build-deps \
    && rm -rf /tmp/* /var/cache/apk/* /usr/src/*

ENTRYPOINT ["clang"]
