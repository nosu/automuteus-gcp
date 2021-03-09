#!/bin/bash

if ! command -v git &> /dev/null
then
  echo "git not found. Installing git..."
  apt-get update
  apt-get install git -y
  echo "...done."
fi

# Install docker-ce & docker-compose
if ! command -v docker &> /dev/null
then
  echo "docker not found. Installing docker..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
  echo "...done."
fi

if ! command -v docker-compose &> /dev/null
then
  echo "docker-compose not found. Installing docker-compose..."
  curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  echo "...done."
fi

# Initial setup
if [ ! -d "~/automuteus" ]; then
  echo "automuteus repo not found. Cloning automuteus repo..."
  git clone --depth 1 https://github.com/denverquane/automuteus.git ~/automuteus
  echo "...done."
  cp ~/automuteus/sample.env ~/automuteus/.env
  sed -i -e "s/AUTOMUTEUS_TAG=/AUTOMUTEUS_TAG=6.11.2/" ~/automuteus/.env
  sed -i -e "s/GALACTUS_TAG=/GALACTUS_TAG=2.4.1/" ~/automuteus/.env
  sed -i -e "s/GALACTUS_EXTERNAL_PORT=/GALACTUS_EXTERNAL_PORT=80" ~/automuteus/.env
fi

# Run on every boot
export DISCORD_BOT_TOKEN=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/DISCORD_BOT_TOKEN")
if [ -z "${DISCORD_BOT_TOKEN}" ];
then
  echo "custom meta-data DISCORD_BOT_TOKEN not found."
  exit 1
fi
sed -i -e "s/^DISCORD_BOT_TOKEN=.*/DISCORD_BOT_TOKEN=${DISCORD_BOT_TOKEN}/" ~/automuteus/.env

if curl -f -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/DISCORD_WORKER_TOKEN";
then
  echo "custom meta-data DISCORD_WORKER_TOKEN found."
  export DISCORD_WORKER_TOKEN=$(curl -f -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/DISCORD_WORKER_TOKEN");
  sed -i -e "s/^WORKER_BOT_TOKENS=.*/WORKER_BOT_TOKENS=${DISCORD_WORKER_TOKEN}/" ~/automuteus/.env
else
  echo "custom meta-data DISCORD_WORKER_TOKEN not found."
  sed -i -e "s/^WORKER_BOT_TOKENS=.*/WORKER_BOT_TOKENS=/" ~/automuteus/.env
fi

export EXTERNAL_IP=$(curl -H "Metadata-Flavor: Google" 'http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip')
sed -i -e "s/^GALACTUS_HOST=.*/GALACTUS_HOST=http:\/\/${EXTERNAL_IP}/" ~/automuteus/.env

cd ~/automuteus
docker-compose up -d
