#!/usr/bin/env bash

# Run script from its folder
CWD=$PWD
# Define repository location
REPO=$GITLAB/sbc-prom.git
# true for the cloud server
DEPLOY=false

docker stop selprom
docker rm selprom
docker rmi selprom

rm -rf sbc-prom
git clone $REPO sbc-prom
cd sbc-prom
git checkout -b prod origin/prod
cd $CWD


docker build -t selprom .

if [ "$DEPLOY" == "true" ]; then
    #    docker run --name nginx-proxy -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy
    # Run container with user's uid to avoid permission issues when updating the repository
    docker run -u `id -u $USER` --name selprom -d -p :7700 -e LD_LIBRARY_PATH='/opt/conda/bin/../lib' -e VIRTUAL_HOST=selprom.synbiochem.co.uk  -v $CWD/sbc-prom:/selprom selprom 
else
    # Run container with user's uid to avoid permission issues when updating the repository
    docker run -u `id -u $USER` --name selprom -d -p 7700:7700 -e LD_LIBRARY_PATH='/opt/conda/bin/../lib' -v $CWD/sbc-prom:/selprom selprom 
fi

