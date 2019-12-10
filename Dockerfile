FROM alpine/git AS clone
RUN git clone --depth 1 https://github.com/schweikert/fping-exporter.git /build

FROM golang:1.12 AS build
COPY --from=clone /build /build
RUN set -xe \
    && cd /build \
    && make before_build \
    && make build

FROM alpine
COPY --from=build /build/fping-exporter_linux_amd64 /usr/bin/fping-exporter
CMD [ "fping-exporter" ]
