## Dockerfile for fourtwenty-net-intelligence-api (build from git).
##
## Build via:
#
# `docker build -t fourtwentynetintel:latest .`
#
## Run via:
#
# `docker run -v <path to app.json>:/home/fourtwentynetintel/fourtwenty-net-intelligence-api/app.json fourtwentynetintel:latest`
#
## Make sure, to mount your configured 'app.json' into the container at
## '/home/fourtwentynetintel/fourtwenty-net-intelligence-api/app.json', e.g.
## '-v /path/to/app.json:/home/fourtwentynetintel/fourtwenty-net-intelligence-api/app.json'
## 
## Note: if you actually want to monitor a client, you'll need to make sure it can be reached from this container.
##       The best way in my opinion is to start this container with all client '-p' port settings and then 
#        share its network with the client. This way you can redeploy the client at will and just leave 'fourtwentynetintel' running. E.g. with
##       the python client 'pyethapp':
##
#
# `docker run -d --name fourtwentynetintel \
# -v /home/user/app.json:/home/fourtwentynetintel/fourtwenty-net-intelligence-api/app.json \
# -p 0.0.0.0:13013:13013 \
# -p 0.0.0.0:13013:13013/udp \
# fourtwentynetintel:latest`
#
# `docker run -d --name pyethapp \
# --net=container:fourtwentynetintel \
# -v /path/to/data:/data \
# pyethapp:latest`
#
## If you now want to deploy a new client version, just redo the second step.


FROM debian

RUN apt-get update &&\
    apt-get install -y curl git-core &&\
    curl -sL https://deb.nodesource.com/setup | bash - &&\
    apt-get update &&\
    apt-get install -y nodejs

RUN apt-get update &&\
    apt-get install -y build-essential

RUN adduser fourtwentynetintel

RUN cd /home/fourtwentynetintel &&\
    git clone https://github.com/cubedro/fourtwenty-net-intelligence-api &&\
    cd fourtwenty-net-intelligence-api &&\
    npm install &&\
    npm install -g pm2

RUN echo '#!/bin/bash\nset -e\n\ncd /home/fourtwentynetintel/fourtwenty-net-intelligence-api\n/usr/bin/pm2 start ./app.json\ntail -f \
    /home/fourtwentynetintel/.pm2/logs/node-app-out-0.log' > /home/fourtwentynetintel/startscript.sh

RUN chmod +x /home/fourtwentynetintel/startscript.sh &&\
    chown -R fourtwentynetintel. /home/fourtwentynetintel

USER fourtwentynetintel
ENTRYPOINT ["/home/fourtwentynetintel/startscript.sh"]
