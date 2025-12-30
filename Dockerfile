# --- FASE 1: Bouw mcrcon (Gebruikt Debian als bouwer) ---
FROM debian:buster-slim as builder

# Setup voor bouwen
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list \
 && sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list \
 && sed -i '/buster-updates/d' /etc/apt/sources.list
RUN apt-get update && apt-get install -y git build-essential gcc

# Compileer mcrcon
RUN git clone https://github.com/Tiiffi/mcrcon.git /tmp/mcrcon
WORKDIR /tmp/mcrcon
RUN gcc -std=gnu11 -pedantic -Wall -Wextra -O2 -s -o mcrcon mcrcon.c

# --- FASE 2: Haal Rclone binnen (De truc!) ---
# We gebruiken de officiële rclone image alleen om het bestandje te pakken
FROM rclone/rclone:latest as rclone_source

# --- FASE 3: De uiteindelijke n8n image ---
FROM n8nio/n8n:latest

USER root

# KOPIEER mcrcon van Fase 1
COPY --from=builder /tmp/mcrcon/mcrcon /usr/local/bin/mcrcon

# KOPIEER rclone van Fase 2
COPY --from=rclone_source /usr/local/bin/rclone /usr/local/bin/rclone

# Zorg dat alles uitvoerbaar is
RUN chmod +x /usr/local/bin/mcrcon && chmod +x /usr/local/bin/rclone

USER node