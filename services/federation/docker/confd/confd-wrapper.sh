#!/bin/bash
set -e  

# pick defaults from original config sample 
export FEDERATION_PORT=${FEDERATION_PORT:-8000}
export FEDERATION_DB_HOST=${FEDERATION_DB_HOST:-localhost}
export FEDERATION_DB_SSLMODE=${FEDERATION_DB_SSLMODE:-disable}
export FEDERATION_DB_NAME=${FEDERATION_DB_NAME:-federation_sample}
export FEDERATION_DB_USER=${FEDERATION_DB_USER:-}
export FEDERATION_DB_PASSWORD=${FEDERATION_DB_PASSWORD:-}
export FEDERATION_QUERY=${FEDERATION_QUERY:-SELECT id FROM people WHERE name = ? AND domain = ?}
export FEDERATION_REVERSE_QUERY=${FEDERATION_REVERSE_QUERY:-SELECT name, domain FROM people WHERE id = ?}
# no default yet in the config file but the current federation server does not start without certs
export FEDERATION_KEY_PATH=${FEDERATION_KEY_PATH:-/localhost.key}
export FEDERATION_CERT_PATH=${FEDERATION_CERT_PATH:-/localhost.crt}

/confd -onetime -backend env

echo "Starting federation server"
exec /wait-for-it.sh ${FEDERATION_DB_HOST}:5432 --timeout=10 --strict -- /federation --conf /federation.cfg

