# Sublink v2.1 Fixed

Based on xeefei/sublink v2.1 (fc90bed).

## Changes

1. IP geolocation lookup runs asynchronously.
2. External IP lookup has a 2-second timeout.
3. Subscription responses are no longer blocked by IP lookup failures.
4. Sublink listens on 127.0.0.1 instead of 0.0.0.0.

## Tested Environment

- Ubuntu 22.04 LTS
- Linux AMD64
- Go 1.26.11
- Sublink v2.1
- Nginx HTTPS reverse proxy

## Build

```bash
go build -o sublink-linux-amd64 .
```

## Deployment Notes

The application listens on 127.0.0.1 by default.

Use Nginx as a reverse proxy for external HTTPS access.

Preserve the existing db, template and configuration files when upgrading an existing installation.

Do not upload production databases, tokens, passwords or server configuration to public repositories.

## Original Project

https://github.com/xeefei/sublink

This fork preserves the original project license.
