# Exposer

Echo full details of any received http(s) requests; i.e. header, path, method, and body.
Details are echoed both in the return bundle (as json) and in the container log.

Multiple listen-ports can be serviced (see examples below).

All requests return 200 OK.

This image is therefore useful to deploy as a diagnostic tool in complex micro-container
environments such as Kubernetes, to allow inspection and tracing of incoming requests.

### Health and Readiness URLS

Health- and readiness- urls are supported; they will always return a simple json and will only be logged at DEBUG level.

These urls default to '/healthz' and '/readiness' and are configurable in /app/exposer.yml.

### Build image

```
./build.sh
```

### Defaults

Exposer always responds to all requests with a 200 OK code.
By default, exposer will bind at port 3000 on all available interfaces, and will log all requests to the container output, at log level 'info'.
```
docker run -it --rm -p3000:3000 exposer
```

### Run locally (in service, listen to 3 ports for app, health, and liveness)

```
MOJO_LISTEN=http://*:3000,http://*:3001,http://*:3002
docker run -it --rm -p3000:3000 -p3001:3001 -p3002:3002 -e MOJO_LISTEN=$MOJO_LISTEN exposer
```

There's no need to distinguish which ports serve which incoming requests.
They are all listened to identically, and requests which match 'health' urls are simply responded to but not logged.

### Kubernetes

Set up a ConfigFile-based volume to override the default /app/exposer.yml, to declare health and readiness endpoints.

Your config file should look something like the following..
```
---
secrets:
  - 60b150d35c130e72b1261b62683c2b113f7f97c0

health_url: '/healthz'
ready_url: '/readiness'

```
The 'secrets' list should be present but for this app is not significant.

Ensure that the environment variable `MOJO_LISTEN` is configured to your deployment (see Docker example above).

### More Options

Exposer is a simple [Mojolicious](https://mojolicious.org) application.  More control is possible via
various other MOJO\_\* environment variables such as `MOJO_LOG_LEVEL` and via other options to the commandline.  See
```
docker run -it --rm exposer script/exposer help
```
or fire up a shell with
```
docker run -it --rm exposer /bin/ash -l
```

### Run locally (development mode)

```
# (clone from GitHub)
cd exposer
docker run -it --rm -p3000:3000 -v$PWD:/app exposer morbo script/exposer
```

### Run self-contained test suite (unit tests)

```
docker run -it --rm exposer prove -lvr t
```

### Run test suite (integration test)

```
# remote server at 'this.deployed.site which forwards internally to exposer at 3000..'
docker run -it --rm -p3000:3000 exposer

# local test suite..
docker run -it --rm -e TEST_SERVER=https://this.deployed.site exposer prove -lvr t

```
