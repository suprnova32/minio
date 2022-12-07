ARG TSVERSION=1.34.0
ARG TSFILE=tailscale_${TSVERSION}_amd64.tgz

FROM alpine:latest as tailscale
ARG TSFILE
WORKDIR /app

RUN wget https://pkgs.tailscale.com/stable/${TSFILE} && \
  tar xzf ${TSFILE} --strip-components=1
COPY . ./

FROM minio/minio:latest

COPY --from=tailscale /app/up.sh /app/up.sh
COPY --from=tailscale /app/tailscaled /app/tailscaled
COPY --from=tailscale /app/tailscale /app/tailscale
RUN mkdir -p /var/run/tailscale
RUN mkdir -p /var/cache/tailscale
RUN mkdir -p /var/lib/tailscale
COPY entrypoint.sh /opt/render/entrypoint.sh
RUN chmod +x /opt/render/entrypoint.sh

ENTRYPOINT ["/opt/render/entrypoint.sh"]
