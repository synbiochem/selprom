#!/usr/bin/env bash
CWD=$PWD
REPO=$GITLAB/sbc-prom.git
DEPLOY=false

if [ "$DEPLOY" == "true" ]; then

    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
    docker rmi $(docker images -q)
else
    docker stop selprom
    docker rm selprom
    docker rmi selprom
fi

rm -rf sbc-prom
git clone $REPO sbc-prom
cd sbc-prom
git checkout -b prod origin/prod
cd $CWD


docker build -t selprom .

if [ "$DEPLOY" == "true" ]; then

    docker run --name nginx-proxy -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy
fi

docker run -u `id -u $USER` --name selprom -d -p 7700:7700 -e LD_LIBRARY_PATH='/opt/conda/bin/../lib' -v $CWD/sbc-prom:/selprom selprom 
