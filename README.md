# openpipe-crosscompile

This repo uses docker in order to download, compile and install a series of softwares based on some input scripts written in bash (the "recipes").

## Build:

```bash
$ image_name="openpipe-payloads"
$ container_name="openpipe/cross-compile"

# For debugging (it's easier to see failures)
$ docker build -t openpipe/cross-compile

# For final release:
$ container_id=$(docker create -ti --name "$image_name" $container_name bash)
```

## Deploy
```bash
$ rm -rf ./generated-payloads
$ mkdir -p ./generated-payloads
# Copy the generated payload locally
$ docker cp $container_id:/opt/payload/install ./generated-payloads
```

## Clean
```bash
$ docker rm -f $container_name
```