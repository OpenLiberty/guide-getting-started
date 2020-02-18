FROM open-liberty
ARG VERSION=1.0
ARG REVISION=SNAPSHOT
LABEL \
  org.opencontainers.image.authors="Graham Charters" \
  org.opencontainers.image.vendor="IBM" \
  org.opencontainers.image.url="local" \
  org.opencontainers.image.source="https://github.com/WASdev/ci.maven" \
  org.opencontainers.image.version="$VERSION" \
  org.opencontainers.image.revision="$REVISION" \
  vendor="Open Liberty" \
  name="system" \
  version="$VERSION-$REVISION" \
  summary="The application from the Getting Started guide" \
  description="This image contains the war file with the Java runtime, running with the Open Liberty runtime."
COPY --chown=1001:0 src/main/liberty/config/ /config/
COPY --chown=1001:0 target/*.war /config/apps/
RUN configure.sh