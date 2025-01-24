#!/bin/bash
sudo apt-get -y update
cd /home/ubuntu && git clone ${repos}
sudo apt -y install make > output.txt

# install docker and waiting until it is installed
sudo snap install docker >> output.txt
sudo snap refresh docker --channel=latest/edge
while ! docker info > /dev/null 2>&1; do
    echo "Aguardando a inicialização do Docker..."
    sleep 1
done

curl -sSL https://install.astronomer.io | sudo bash

# principal folder
cd economic_data_extraction

# astro config

sleep 10
sudo astro dev start >> output_astro.txt