#!/bin/sh

/app/tailscale up \
  --authkey=${TAILSCALE_AUTHKEY} \
  --hostname=render-tailscale \
  --advertise-exit-node \
  --accept-routes --reset
