FROM mths/docker-pmdrr
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
ENV NODE_VERSION 8.11.4

WORKDIR /.nvm

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash \
    && . /.nvm/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH /.nvm/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      /.nvm/versions/node/v$NODE_VERSION/bin:$PATH