# Exposer

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
