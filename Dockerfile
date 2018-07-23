FROM aoberegg/docker-pmdrrnode

RUN apt-get remove -y nodejs
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN apt-get install -y nodejs
