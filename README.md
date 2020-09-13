# Exposer

Echo full details of any received http(s) requests; i.e. header, path, method, and body.
Details are echoed both in the return bundle (as json) and in the container log.

Multiple listen-ports can be serviced (see examples below).

All requests return 200 OK.

This image is therefore useful to deploy as a diagnostic tool in complex micro-container
environments such as Kubernetes, to allow inspection of incoming requests.

### Health and Readiness URLS

Health- and readiness- urls are supported; they will always return a simple json and will only be logged at DEBUG level.

These urls default to '/healthz' and '/readiness' and are configurable in /app/exposer.yml.

To silence logging of these, move logging level to 'info' (recommended), by adding `-m production` to any of the below examples.

### build image

```
./build.sh
```

### run locally (development)

```
cd exposer
docker run -it --rm -p3001:3001 -v$PWD:/app exposer morbo script/exposer -l 'http://*:3001'
```

### run locally (in service, listen to ports for app, health, and liveness)

```
docker run -it --rm -p3000:3000        -p3001:3001        -p3002:3002 exposer script/exposer \
       daemon -l 'http://*:3000' -l 'http://*:3001' -l 'http://*:3002'
```

### run self-contained test suite (unit tests)

```
docker run -it --rm exposer prove -lvr t
```

### run test suite (integration test)

```
# server..
docker run -it --rm -p3000:3000 exposer script/exposer daemon -l 'http://*:3000'

# test suite..
docker run -it --rm -e TEST_SERVER=https://this.deployed.site:3000 exposer prove -lvr t

```

### deploy live

```
docker run -it --rm -p3000:3000        -p3001:3001        -p3002:3002 exposer script/exposer \
       daemon -l 'http://*:3000' -l 'http://*:3001' -l 'http://*:3002' -m production
```

### Kubernetes

Set up a ConfigFile to override /app/exposer.yml to declare health and readiness endpoints.

Sample command: `script/exposer daemon -l 'http://*:3000' -l 'http://*:3001' -l 'http://*:3002' -m production`

There's no need to distinguish which ports serve which incoming requests.
They are all listened to identically, and requests which match 'health' urls are simply responded to but not logged.

