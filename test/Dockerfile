# Extraction stage
FROM busybox:latest AS extractor
COPY publish/*.zip /plugin.zip
RUN unzip /plugin.zip -d /extracted

# Runtime stage with Jellyfin
FROM jellyfin/jellyfin:latest
LABEL maintainer="FinTube Plugin"
LABEL description="Jellyfin with FinTube Plugin"

# Copy the extracted plugin from the extractor stage to a temp location
COPY --from=extractor /extracted /temp-plugin/
COPY test/startup.sh /startup.sh
RUN chmod +x /startup.sh

EXPOSE 8096 8920 1900/udp 7359/udp

VOLUME /config
VOLUME /cache
VOLUME /media

ENTRYPOINT ["/startup.sh"]
