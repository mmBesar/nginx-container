FROM alpine:latest

# Install NGINX with fancyindex and WebDAV support (nginx-full includes most modules)
RUN apk add --no-cache \
    nginx-full \
    ffmpeg \
    openssl \
    pcre \
    zlib \
    bash \
    wget \
    curl

# Remove default site configs
RUN rm -rf /etc/nginx/conf.d/*

# Set up volume mount points
RUN mkdir -p /config/nginx /config/www /var/www && \
    ln -sf /config/nginx /etc/nginx/conf.d && \
    ln -sf /config/www /var/www/html

# Expose common ports (HTTP, HTTPS, RTMP)
EXPOSE 80 443 1935

# Start NGINX in foreground
CMD ["nginx", "-g", "daemon off;"]
