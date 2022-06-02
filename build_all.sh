#!/bin/bash

image_name="openpipe-payloads"
container_name="openpipe/cross-compile"

#docker build -t openpipe/cross-compile .
docker rm -f $image_name

echo "Creating container $container_name, image_name: $image_name"
container_id=$(docker create -ti --name "$image_name" $container_name bash)

echo "Copying generated payload"
docker cp "$container_id:/opt/payload/install" ./generated-payloads
