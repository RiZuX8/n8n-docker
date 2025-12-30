# Fase 1: Bouw mcrcon (op Alpine basis)
FROM alpine:3.18 as builder

RUN apk add --no-cache git build-base

RUN git clone https://github.com/Tiiffi/mcrcon.git /tmp/mcrcon
WORKDIR /tmp/mcrcon
RUN gcc -std=gnu11 -pedantic -Wall -Wextra -O2 -s -o mcrcon mcrcon.c

# Fase 2: De n8n image (Expliciet ALPINE)
FROM n8nio/n8n:alpine

USER root

# Nu MOET apk wel werken, want de basis is 100% zeker Alpine
RUN apk add --no-cache rclone

COPY --from=builder /tmp/mcrcon/mcrcon /usr/local/bin/mcrcon
RUN chmod +x /usr/local/bin/mcrcon

USER node