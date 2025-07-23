FROM alpine:3.22 AS builder

RUN apk add --no-cache \
    git build-base pcre-dev openssl-dev zlib-dev linux-headers wget curl bash

# Get NGINX source
ENV NGINX_VERSION=1.26.1
WORKDIR /build

RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -zxvf nginx-${NGINX_VERSION}.tar.gz

# Clone RTMP and FancyIndex modules
RUN git clone https://github.com/arut/nginx-rtmp-module.git && \
    git clone https://github.com/aperezdc/ngx-fancyindex.git

# Build NGINX with modules
WORKDIR /build/nginx-${NGINX_VERSION}
RUN ./configure \
    --prefix=/opt/nginx \
    --add-module=../nginx-rtmp-module \
    --add-module=../ngx-fancyindex \
    --with-http_ssl_module \
    --with-http_dav_module \
    --with-http_stub_status_module && \
    make && make install

# Final image
FROM alpine:3.22

RUN apk add --no-cache openssl pcre zlib bash curl

COPY --from=builder /opt/nginx /opt/nginx

# Create config directories
RUN mkdir -p /config/nginx /config/www /var/log/nginx

# Symlink config and root
RUN ln -sf /config/nginx /opt/nginx/conf && \
    ln -sf /config/www /opt/nginx/html

ENV PATH="/opt/nginx/sbin:$PATH"

EXPOSE 80 443 1935

CMD ["nginx", "-g", "daemon off;"]
