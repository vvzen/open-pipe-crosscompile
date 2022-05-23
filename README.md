# openpipe-crosscompile

This repo uses docker in order to download, compile and install a series of softwares based on some input scripts written in bash (the "recipes").

## Build:

```bash
$ container_id=$(docker create -ti --name openpipe-payloads openpipe/cross-compile bash)
```

## Run
```bash
docker run openpipe/cross-compile
```

## Deploy
```bash
rm -rf ./generated-payloads
mkdir -p ./generated-payloads
# Copy the generated payload locally
docker cp $container_id:/opt/payload/install ./generated-payloads
```
