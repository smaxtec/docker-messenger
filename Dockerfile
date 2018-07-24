FROM aoberegg/docker-pmdrrnode

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
# Install nvm and specific nodeversion
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 6.11.0

WORKDIR $NVM_DIR

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
RUN node --version

ENV FIREFOX_VERSION=59.0.2 PHANTOMJS_VERSION=2.1.1 CHROME_VERSION=stable_current \
    SCREEN_WIDTH=1000 SCREEN_HEIGHT=800 SCREEN_DEPTH=24

RUN rm -rf /var/lib/apt/lists/* && apt-get -q update &&\
  apt-get install -qy --force-yes xvfb fontconfig bzip2 curl \
    libxss1 libappindicator1 libindicator7 libpango1.0-0 fonts-liberation xdg-utils gconf-service \
  &&\
  apt-get clean &&\
  rm -rf /var/lib/apt/lists/* &&\
  rm -rf /tmp/*

RUN curl --silent --show-error --location --fail --retry 3 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2 | tar xjfO - phantomjs-${PHANTOMJS_VERSION}-linux-x86_64/bin/phantomjs > /usr/bin/phantomjs && chmod +x /usr/bin/phantomjs

# RUN curl --silent --show-error --location --fail --retry 3 https://dl.google.com/linux/direct/google-chrome-${CHROME_VERSION}_amd64.deb > /tmp/google-chrome-${CHROME_VERSION}_amd64.deb && dpkg -i /tmp/google-chrome-${CHROME_VERSION}_amd64.deb && rm /tmp/google-chrome-${CHROME_VERSION}_amd64.deb

RUN curl --silent --show-error --location --fail --retry 3 http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/${FIREFOX_VERSION}/linux-x86_64/en-US/firefox-${FIREFOX_VERSION}.tar.bz2 > /tmp/firefox-${FIREFOX_VERSION}.tar.bz2 && mkdir /opt/firefox-${FIREFOX_VERSION} && tar xjf /tmp/firefox-${FIREFOX_VERSION}.tar.bz2 -C /opt/firefox-${FIREFOX_VERSION} && rm /tmp/firefox-${FIREFOX_VERSION}.tar.bz2

RUN export DISPLAY=:99

RUN echo '#!/bin/bash' > /usr/bin/firefox &&\
    echo 'export $(dbus-launch) && set | grep -i dbus && exec xvfb-run -a -s "-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_DEPTH} -ac +extension RANDR" /opt/firefox-${FIREFOX_VERSION}/firefox/firefox "$@"' >> /usr/bin/firefox &&\
    chmod +x /usr/bin/firefox

RUN apt-get update
RUN apt-get install -y chromium-browser

RUN ln -s /usr/bin/chromium-browser /usr/bin/google-chrome

# RUN mv /opt/google/chrome/google-chrome /opt/google/chrome/google-chrome.orig &&\
#     echo '#!/bin/bash' > /opt/google/chrome/google-chrome &&\
#     echo 'exec xvfb-run -a -s "-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_DEPTH} -ac +extension RANDR" /opt/google/chrome/google-chrome.orig --no-sandbox "$@"' >> /opt/google/chrome/google-chrome &&\
#     chmod +x /opt/google/chrome/google-chrome
