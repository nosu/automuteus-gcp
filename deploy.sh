#!/bin/bash

if [ -z "${DISCORD_BOT_TOKEN}" ];
then
  echo "Need to export a environment variable DISORD_BOT_TOKEN as below"
  echo "export DISCORD_BOT_TOKEN="
  exit 1
fi

gcloud config set compute/zone us-west1-b

gcloud compute instances create automuteus \
--machine-type=f1-micro \
--boot-disk-size=30GB \
--boot-disk-type=pd-standard \
--image-project debian-cloud \
--image-family=debian-10 \
--tags=http-server \
--metadata-from-file startup-script=./setup_vm.sh \
--metadata DISCORD_BOT_TOKEN=${DISCORD_BOT_TOKEN}
