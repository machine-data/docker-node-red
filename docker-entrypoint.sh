#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1:0:1}" = '-' ]; then
    set -- node-red "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'node-red' -a "$(id -u)" = '0' ]; then
    chown -R node-red:node-red /config /data
    exec su-exec node-red "$0" "$@"
fi

if [ "$1" = 'node-red' ]; then

    # if undefined, populate environment variables with sane defaults
    : ${NODE_RED_FLOW_FILE='flows.json'}
    : ${NODE_RED_USER_DIR='/data'}

    # if no configfile is provided, generate one based on the environment variables
    if [ ! -f /config/settings.js ]; then

        # use dist config file and replace settings
        sed -e "s#//flowFile: '.*'#flowFile: '$NODE_RED_FLOW_FILE'#" \
            -e "s#//userDir: '.*'#userDir: '$NODE_RED_USER_DIR'#" \
            \
            /config/settings.js.dist > /config/settings.js
    fi
fi

exec "$@"
