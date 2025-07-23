FROM alpine:latest

# Install nginx and dynamic modules
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

# Build nginx with RTMP module
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
    make && make install && rm -rf /build

# Ensure required directories exist
RUN mkdir -p /config/site-confs /config/www /var/log/nginx

# Expose relevant ports
EXPOSE 80 443 1935

# Entrypoint: use config from /config/nginx.conf
CMD ["nginx", "-c", "/config/nginx.conf", "-g", "daemon off;"]
