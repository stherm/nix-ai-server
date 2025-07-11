USER="$(whoami)"
HOST="X99S"
DOMAIN="steffen.fail"
PORT="2299"

NIX_SSHOPTS="-p $PORT" rebuild nixos -p . -H "$HOST" -B "$USER"@"$DOMAIN" -T "$USER"@"$DOMAIN"
