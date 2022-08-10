FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 \
    && apt update \
    && apt install -y --no-install-recommends \
        clang \
        g++-multilib \
        lib32stdc++-7-dev \
        lib32z1-dev \
        libc6-dev-i386 \
        linux-libc-dev:i386 \
        curl \
        ca-certificates

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

RUN useradd -m -d /app game

USER game

ENV HOME /app

WORKDIR /app

RUN mkdir -p /steamcmd

RUN curl -sSL -o /tmp/steamcmd.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz

RUN tar -xzvf /tmp/steamcmd.tar.gz -C /steamcmd

RUN rm -rf /tmp/*

ENTRYPOINT ["/entrypoint.sh"]
