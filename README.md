# Supported tags and respective `Dockerfile` links

- `latest`, `1`, `1.6`, `1.6.2` [(Dockerfile)](https://github.com/machine-data/docker-oauth2_proxy/blob/master/Dockerfile)

- `1.5`, `1.5.1` [(Dockerfile)](https://github.com/machine-data/docker-node-red/blob/v1.5.1/Dockerfile)

# Node-RED on Docker

This repository holds a build definition and supporting files for building a Docker image to run [Node-RED](https://nodered.org).
It is published as automated build `machinedata/node-red` on [Docker Hub](https://registry.hub.docker.com/u/machinedata/node-red/).

## What is Node-RED?

[Node-RED](https://nodered.org) is a tool for wiring together hardware devices, APIs and online services in new and interesting ways.

## Yet another Node-RED container?

Not quite:
- Based on the official Alpine Linux image - super slim and lightweight.
- Only node.js and node-gyp as dependency (needed by some [add-on packages](https://flows.nodered.org)).
- No magic. Straight config that follows upstream. Simple and clean configuration via environment variables _or_ config file.
- Image follows [Dockerfile best practices](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/) (dropping root privileges, PID1 for proper signalling, logging,...)
- All user data under `/data` - ready-to mount.

## Quickstart

Simply start Node-RED and access it via `http://{HOSTNAME}:1880`:

```sh
$ docker run -d -p 1880:1880 machine-data/node-red
```

Application data (flows and add-on modules) is being stored in `/data`, therefore it is recommended to bind mount a volume.

```sh
$ mkdir data
$ docker run -d \
	--volume $(pwd)/data:/data \
	--publish 1880:1880 \
	machine-data/node-red
```

## Environment variables

It is very easy to configure Node-RED via environment variables. If no config file is present, the `docker-entrypoint.sh` script will create one based on sane defaults and environment variables.

- `NODE_RED_FLOW_FILE`: The file containing the flows. If not set, the image defaults `flowFile` to `flows.json`.

- `NODE_RED_USER_DIR`: The directory where all user data is stored. This translates to `userDir` in `settings.js`. In most cases it makes sense to keep the `/data` default.

--
**Example**: Starting Node-RED with `my_flow.json` from the host data directory `/mnt/data/nodered/`:

```sh
$ mkdir -p /mnt/data/flows
$ touch /mnt/data/flows/my_flow.json
$ docker run -d \
             -e NODE_RED_FLOW_FILE=my_flow.json \
             -v /mnt/data/flows:/data \
             -p 1880:1880 machine-data/node-red
```

will start Node-RED with the `myflow.json` flow.

**Note**: Node.js will also respect its own `NPM_CONFIG_` variables.

## Configuration file

The container is configured to start Node-RED with `/config/settings.js` as config file.
If a config file is mounted (preferably read-only), the `NODE_RED_` environment variables will be ignored:

```sh
$ curl -O https://raw.githubusercontent.com/node-red/node-red/master/settings.js
$ sed -i -e "s#//userDir: '.*'#userDir: '/data'#" settings.js
$ docker run -d \
             -v $(pwd)/settings.js:/config/settings.js:ro \
             -p 1880:1880 machine-data/node-red
```

## Volumes

- `/data`: Path where Node-RED's data is stored (userDir in Node-RED configuration).
  Packages that are installed via the webinterface will be stored in `/data/node_modules`.

When installing additional packages the npm installer will create a download cache under `/tmp/.npm` and further temp files in  `/tmp/.npm-*`. You might want to bind mount your local temporary directory.
To change these paths you need to overwrite the `NPM_CONFIG_TMP` and `NPM_CONFIG_CACHE` environment variables.

## Ports

- `1880`: The default port where Node-RED is listening. Can be changed via `$PORT` environment variable.

## Legal

Node-RED is a project of the JS Foundation and is a creation of [IBM Emerging Technology](https://www.ibm.com/blogs/emerging-technology/), authored by [Nick O'Leary](https://twitter.com/knolleary) and [Dave Conway-Jones](https://twitter.com/ceejay).
Copyright JS Foundation and other contributors, [http://js.foundation/](http://js.foundation/) under the [Apache 2.0 license](https://github.com/node-red/node-red/blob/master/LICENSE).

docker-node-red is licensed under the [Apache 2.0 license](https://github.com/machine-data/docker-node-red/blob/master/LICENSE), was created by [Jodok Batlogg](https://github.com/jodok).
Copyright 2016-2017 [Crate.io, Inc.](https://crate.io).

## Contributing

Thanks for considering contributing to docker-node-red!
The easiest way to contribute is either by filing an [issue on Github](https://github.com/machine-data/docker-node-red/issues) or to [fork the repository](https://github.com/machine-data/docker-node-red/fork) to create a pull request.

If you have any questions don't hesitate to join us on Slack.
