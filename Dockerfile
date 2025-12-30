# Fase 1: Bouw mcrcon op Alpine
FROM alpine:latest as builder

# Installeer bouw-tools (gcc, make, git)
RUN apk add --no-cache git build-base

# Download en compileer mcrcon
RUN git clone https://github.com/Tiiffi/mcrcon.git /tmp/mcrcon
WORKDIR /tmp/mcrcon
# Compileer commando voor Alpine (gcc)
RUN gcc -std=gnu11 -pedantic -Wall -Wextra -O2 -s -o mcrcon mcrcon.c

# Fase 2: De definitieve n8n image (Alpine versie)
FROM n8nio/n8n:latest

# Wordt root om te installeren
USER root

# Installeer rclone via apk (Alpine package manager)
RUN apk add --no-cache rclone

# Kopieer mcrcon van de bouwer
COPY --from=builder /tmp/mcrcon/mcrcon /usr/local/bin/mcrcon
RUN chmod +x /usr/local/bin/mcrcon

# Terug naar n8n gebruiker
USER node