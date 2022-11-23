#!/usr/bin/env sh
# wrapper for docker entrypoint that takes into account the PORT env var
echo 'Starting up tailscale...'

/app/tailscaled --verbose=1 --port 41641 --tun=userspace-networking --socks5-server=localhost:1055 &
sleep 5
if [ ! -S /var/run/tailscale/tailscaled.sock ]; then
    echo "tailscaled.sock does not exist. exit!"
    exit 1
fi

/app/up.sh

exec docker-entrypoint.sh server --console-address ":10000" --address ":9000" /data
