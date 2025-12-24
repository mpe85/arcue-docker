FROM debian:trixie-slim AS builder

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

ARG VERSION="2.2.6"
ARG FILENAME="CUETools_${VERSION}.zip"
ARG DOWNLOAD_URL="https://github.com/gchudov/cuetools.net/releases/download/v${VERSION}"
ARG CURL_FLAGS="-sSL --retry 3 --retry-delay 5 --retry-connrefused"

WORKDIR /build

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl libarchive-tools

RUN curl ${CURL_FLAGS} -O "${DOWNLOAD_URL}/${FILENAME}" && \
    curl ${CURL_FLAGS} -O "${DOWNLOAD_URL}/${FILENAME}.sha256" && \
    sha256sum -c "${FILENAME}.sha256" && \
    bsdtar -xf "${FILENAME}" --strip-components=1 && \
    rm "${FILENAME}" "${FILENAME}.sha256" && \
    find . -type f -name '*.exe' ! -name 'CUETools.ARCUE.exe' -delete

FROM debian:trixie-slim

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

RUN groupadd -g 1000 arcue && \
    useradd -u 1000 -g arcue -m -d /home/arcue arcue

WORKDIR /opt/arcue
VOLUME /data

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates mono-runtime libmono-system-drawing4.0-cil && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder --chown=arcue:arcue /build /opt/arcue

WORKDIR /data
USER arcue

ENTRYPOINT ["mono", "/opt/arcue/CUETools.ARCUE.exe"]
