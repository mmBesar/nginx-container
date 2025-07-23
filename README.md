# nginx-container

Custom NGINX container with:

- ✅ Fancyindex support
- ✅ WebDAV with optional auth
- ✅ RTMP for live video streaming

## 🚀 Usage

```bash
docker run -d -p 80:80 -p 443:443 -p 1935:1935 ghcr.io/mmbesar/nginx-container
````

## 🛠️ Build Locally

```bash
docker build -t nginx-container .
```

---

## Optional: Add Basic Auth File

Generate `.htpasswd` for WebDAV:

```bash
apk add apache2-utils
htpasswd -c webdav.htpasswd username
```
