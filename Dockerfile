FROM debian:trixie-slim

ARG VERSION="2.2.6"

WORKDIR /opt/cuetools
VOLUME /data

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh && \
    apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl mono-runtime libarchive-tools libmono-system-drawing4.0-cil && \
    curl -sL https://github.com/gchudov/cuetools.net/releases/download/v${VERSION}/CUETools_${VERSION}.zip | bsdtar -xf - --strip-components=1 && \
    find . -type f -name '*.exe' ! -name 'CUETools.ARCUE.exe' -delete && \
    apt-get purge -y --auto-remove ca-certificates curl libarchive-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /data

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
