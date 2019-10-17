FROM open-liberty

LABEL maintainer="Graham Charters" vendor="IBM" github="https://github.com/WASdev/ci.maven"

COPY --chown=1001:0 src/main/liberty/config/ /config/
COPY --chown=1001:0 target/*.war /config/apps/
