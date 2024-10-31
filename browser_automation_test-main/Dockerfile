FROM ubuntu:20.04

MAINTAINER CITC OCAIP
LABEL description Robot Framework in Docker.

# Setup X Window Virtual Framebuffer
ENV SCREEN_COLOUR_DEPTH 24
ENV SCREEN_HEIGHT 1080
ENV SCREEN_WIDTH 1920

# Setup the timezone to use, defaults to UTC
ENV TZ Asia/Taipei

# Set number of threads for parallel execution
# By default, no parallelisation
ENV ROBOT_THREADS 1

# Noninteractive for tzdata
ENV DEBIAN_FRONTEND noninteractive

# Dependency versions
ENV CHROME_DRIVER_VERSION 91.0.4472.101
ENV CHROMIUM_VERSION 73.0.*
ENV FAKER_VERSION 5.0.0
ENV FIREFOX_VERSION 68.0*
ENV GECKO_DRIVER_VERSION v0.22.0
ENV PABOT_VERSION 1.8.0
ENV ROBOT_FRAMEWORK_VERSION 3.1.2
ENV SELENIUM_LIBRARY_VERSION 4.3.0
ENV REQUESTS_VERSION 0.7.0
ENV SCREENCAP_VERSION 1.5.0

# Install system dependencies
RUN apt-get upgrade -y \
 && apt-get update \
 && apt-get install -y \
    software-properties-common \
    curl \
    wget \
    unzip \
    iputils-ping \
    #chromium-browser=$CHROMIUM_VERSION \
    #firefox=$FIREFOX_VERSION \
    xauth \
    xvfb \
    python3-pip \
    python3-tk \
    gir1.2-gtk-3.0 \
    language-pack-zh-hant language-pack-zh-hans \
    ttf-wqy-zenhei ttf-wqy-microhei fonts-arphic-ukai fonts-arphic-uming \
    ca-certificates \
    jq \
    libxml2-utils \
 && apt-get clean all

COPY bin/ITRIroot256.crt /usr/local/share/ca-certificates/
RUN chmod 644 /usr/local/share/ca-certificates/ITRIroot256.crt && update-ca-certificates

#Firefox en-US
RUN wget "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US" -O /opt/firefox-en-US.tar.bz2 \
    && tar jxf /opt/firefox-en-US.tar.bz2 -C /opt && mv /opt/firefox /opt/firefox-en-US \
    && ln -s /opt/firefox-en-US/firefox /usr/local/bin/firefox-en-US
#Firefox zh-TW
RUN wget "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=zh-TW" -O /opt/firefox-zh-TW.tar.bz2 \
    && tar jxf /opt/firefox-zh-TW.tar.bz2 -C /opt && mv /opt/firefox /opt/firefox-zh-TW \
    && ln -s /opt/firefox-zh-TW/firefox /usr/local/bin/firefox-zh-TW

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update && apt-get install -y google-chrome-stable \
    && wget -q "http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_$CHROME_DRIVER_VERSION-1_amd64.deb" -O google-chrome.deb \
    && dpkg -i google-chrome.deb

# update pip
RUN pip3 install --no-cache-dir pip --upgrade

# Setup language and font setting
ENV LANG zh_TW.UTF-8
COPY bin/fonts/ /usr/share/fonts/
COPY bin/fonts/local.conf /etc/fonts/local.conf

# Install Robot Framework and Selenium Library
RUN pip3 install --no-cache-dir \
  robotframework==$ROBOT_FRAMEWORK_VERSION \
  robotframework-faker==$FAKER_VERSION \
  robotframework-pabot==$PABOT_VERSION \
  robotframework-seleniumlibrary==$SELENIUM_LIBRARY_VERSION \
  robotframework-requests==$REQUESTS_VERSION \
  robotframework-screencaplibrary==$SCREENCAP_VERSION \
  cython

# Prepare requirment package
RUN mkdir -p /opt/robotframework
COPY ./requirements.txt /opt/robotframework

# Install Script Packages
RUN pip3 install --no-cache-dir -r /opt/robotframework/requirements.txt

# Install chromedriver
RUN wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/ \
 && unzip ~/chromedriver_linux64.zip -d ~/ \
 && rm ~/chromedriver_linux64.zip \
 && mv -f ~/chromedriver /usr/local/bin/chromedriver \
 && chown root:root /usr/local/bin/chromedriver \
 && chmod 0755 /usr/local/bin/chromedriver

# Download Gecko drivers directly from the GitHub repository
RUN wget -q "https://github.com/mozilla/geckodriver/releases/download/$GECKO_DRIVER_VERSION/geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz" \
      && tar xzf geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz \
      && mkdir -p /opt/robotframework/drivers/ \
      && mv geckodriver /opt/robotframework/drivers/geckodriver \
      && rm geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz

# Prepare binaries to be executed
COPY bin/run-tests-in-virtual-screen.sh /opt/robotframework/bin/

# Prepare for AIdea-CLI
RUN pypath="$(python3 -c 'import aidea; print(aidea.__path__[0])')" \
    && cat ${pypath}/tools.py | sed "s/aidea-web/ocaip-dev.xaas/g" \
       | sed "s/getpass('password/input('password/g" | tee ${pypath}/tools.py > /dev/null

# Update system path
ENV PATH=/opt/robotframework/bin:/opt/robotframework/drivers:$PATH

# Execute all robot tests
CMD ["run-tests-in-virtual-screen.sh"]
