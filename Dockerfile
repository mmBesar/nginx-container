FROM alpine:latest

RUN apk add --no-cache \
    nginx \
    nginx-mod-http-dav \
    nginx-mod-http-fancyindex \
    openssl \
    pcre \
    zlib \
    ffmpeg \
    git \
    build-base \
    wget

RUN mkdir -p /build && cd /build && \
    wget http://nginx.org/download/nginx-1.25.5.tar.gz && \
    tar -xzf nginx-1.25.5.tar.gz && \
    git clone https://github.com/arut/nginx-rtmp-module && \
    cd nginx-1.25.5 && \
    ./configure \
      --prefix=/etc/nginx \
      --sbin-path=/usr/sbin/nginx \
      --conf-path=/etc/nginx/nginx.conf \
      --with-http_ssl_module \
      --add-module=../nginx-rtmp-module && \
    make && make install && \
    cd / && rm -rf /build

EXPOSE 80 443 1935

CMD ["nginx", "-g", "daemon off;"]
