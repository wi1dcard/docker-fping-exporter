FROM alpine/git AS clone
RUN git clone --depth 1 https://github.com/schweikert/fping-exporter.git /build

FROM golang:1.12 AS build
COPY --from=clone /build /build
RUN set -xe \
    && cd /build \
    && make before_build \
    && CGO_ENABLED=0 make build

FROM alpine
RUN apk add --no-cache fping
COPY --from=build /build/fping-exporter_linux_amd64 /usr/bin/fping-exporter
CMD [ "fping-exporter", "--fping=/usr/sbin/fping" ]
