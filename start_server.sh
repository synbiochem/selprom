#!/usr/bin/env bash

# Run script from its folder
CWD=$PWD
# Define repository location
GITLAB=ssh://gitlab@gitlab.cs.man.ac.uk:22222/pablo-carbonell
REPO=$GITLAB/sbc-prom.git
# true for the cloud server, false for local installation
DEPLOY=true
if [ "$USER" == "pablo" ]; then
    DEPLOY=false
fi

# Delete old containers
docker stop selprom
docker rm selprom
docker rmi selprom

# Update repository and change to production branch
rm -rf sbc-prom
git clone $REPO sbc-prom
cd sbc-prom
git checkout -b prod origin/prod
cd $CWD

# Build new image
docker build -t selprom .

# Run container
if [ "$DEPLOY" == "true" ]; then
    #    docker run --name nginx-proxy -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy
    # Run container with user's uid to avoid permission issues when updating the repository
    docker run -u `id -u $USER` --name selprom -d -p 7700:7700 -e LD_LIBRARY_PATH='/opt/conda/bin/../lib' -e VIRTUAL_HOST=selprom.synbiochem.co.uk  -v $CWD/sbc-prom:/selprom selprom 
else
    # Run container with user's uid to avoid permission issues when updating the repository
    docker run -u `id -u $USER` --name selprom -d -p 7700:7700 -e LD_LIBRARY_PATH='/opt/conda/bin/../lib' -v $CWD/sbc-prom:/selprom selprom 
fi

