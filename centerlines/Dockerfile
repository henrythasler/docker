FROM python:3.7.3-slim-stretch

RUN apt-get update && apt-get install -y --no-install-recommends \
      git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
RUN git clone --branch master --depth 1 https://github.com/ungarj/label_centerlines.git /usr/src/app &&\
    pip3 install --no-cache-dir -r requirements.txt &&\
    python3 setup.py install

ENTRYPOINT ["label_centerlines"]
CMD ["--help"]
