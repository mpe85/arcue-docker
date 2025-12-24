FROM debian:trixie-slim AS builder

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

ARG VERSION="2.2.6"

WORKDIR /build

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl libarchive-tools

RUN curl -sL "https://github.com/gchudov/cuetools.net/releases/download/v${VERSION}/CUETools_${VERSION}.zip" | \
    bsdtar -xf - --strip-components=1 && \
    find . -type f -name '*.exe' ! -name 'CUETools.ARCUE.exe' -delete

FROM debian:trixie-slim

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

WORKDIR /opt/cuetools
VOLUME /data

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates mono-runtime libmono-system-drawing4.0-cil && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /build /opt/cuetools
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /data

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]