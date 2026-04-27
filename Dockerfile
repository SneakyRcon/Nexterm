ARG SERVER_IMAGE=nexterm/server:latest
ARG ENGINE_IMAGE=nexterm/engine:latest

FROM ${ENGINE_IMAGE} AS engine
FROM ${SERVER_IMAGE}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       libcairo2 libjpeg62-turbo libpng16-16t64 libossp-uuid16 \
       libpango-1.0-0 libwebp7 openssl libpulse0 libvorbis0a libogg0 \
       libssh2-1t64 libvncserver1 libfreerdp3-3 libcurl4t64 \
       util-linux smbclient \
    && rm -rf /var/lib/apt/lists/*

COPY --from=engine /usr/local/lib/ /usr/local/lib/

COPY --from=engine /usr/local/bin/nexterm-engine /usr/local/bin/nexterm-engine

COPY --from=engine /usr/lib/freerdp3/ /usr/lib/freerdp3/

RUN echo /usr/local/lib > /etc/ld.so.conf.d/nexterm.conf \
    && echo /usr/local/lib/freerdp3 >> /etc/ld.so.conf.d/nexterm.conf \
    && echo /usr/lib/freerdp3 >> /etc/ld.so.conf.d/nexterm.conf \
    && ldconfig

EXPOSE 6989

CMD ["/bin/sh", "docker-start.sh"]
