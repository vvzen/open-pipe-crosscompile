# openpipe-crosscompile

This repo uses docker in order to download, compile and install a series of softwares based on some input scripts written in bash (the "recipes").

## Build:

```bash
$ image_name="openpipe-payloads"
$ container_name="openpipe/cross-compile"
$ container_id=$(docker create -ti --name "$image_name" $container_name bash)
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

## Clean
```bash
docker rm -f $container_name
```