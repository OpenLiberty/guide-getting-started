FROM open-liberty as server-setup
COPY /target/getting-started.zip /config/
USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip \
    && unzip /config/getting-started.zip \
    && mv /wlp/usr/servers/GettingStartedServer/* /config/ \
    && rm -rf /config/wlp \
    && rm -rf /config/getting-started.zip 

FROM open-liberty
LABEL maintainer="Graham Charters" vendor="IBM" github="https://github.com/WASdev/ci.maven"
COPY --chown=1001:0 --from=server-setup /config/ /config/
EXPOSE 9080 9443
