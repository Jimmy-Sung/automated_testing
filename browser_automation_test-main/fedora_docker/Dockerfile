FROM fedora:30

MAINTAINER Paul Podgorsek <ppodgorsek@users.noreply.github.com>
LABEL description Robot Framework in Docker.

# Setup volumes for input and output
VOLUME /opt/robotframework/reports
VOLUME /opt/robotframework/tests

# Setup X Window Virtual Framebuffer
ENV SCREEN_COLOUR_DEPTH 24
ENV SCREEN_HEIGHT 1080
ENV SCREEN_WIDTH 1920

# Set number of threads for parallel execution
# By default, no parallelisation
ENV ROBOT_THREADS 1

# Dependency versions
ENV CHROMIUM_VERSION 73.0.*
ENV FAKER_VERSION 4.2.0
ENV FIREFOX_VERSION 68.0*
ENV GECKO_DRIVER_VERSION v0.22.0
ENV PABOT_VERSION 0.46
ENV PYTHON_PIP_VERSION 19.0*
ENV ROBOT_FRAMEWORK_VERSION 3.0.4
ENV SELENIUM_LIBRARY_VERSION 3.3.1
ENV XVFB_VERSION 1.20.*
ENV REQUESTS_VERSION 0.4.7

# Select Fastest Mirror Site
RUN echo "fastestmirror=true" >> /etc/dnf/dnf.conf

# Install system dependencies
RUN dnf upgrade -y \
  && dnf install -y \
    chromedriver-$CHROMIUM_VERSION \
    firefox-$FIREFOX_VERSION \
    python2-pip-$PYTHON_PIP_VERSION \
    xauth \
    xorg-x11-server-Xvfb-$XVFB_VERSION \
    which \
    wget \
    python-tkinter \
    vim \
    langpacks-zh_TW \
    procps \
    psmisc \
    'dnf-command(config-manager)' \
    fedora-workstation-repositories \
  && dnf clean all

RUN dnf config-manager --set-enabled google-chrome && dnf install -y google-chrome-stable

COPY bin/ITRIroot256.crt /usr/local/share/ca-certificates/
RUN chmod 644 /usr/local/share/ca-certificates/ITRIroot256.crt && update-ca-certificates

# Setup language and font setting
ENV LANG zh_TW.UTF-8
COPY bin/fonts/ /usr/share/fonts/
COPY bin/fonts/local.conf /etc/fonts/local.conf

# Install Robot Framework and Selenium Library
RUN pip install \
  robotframework==$ROBOT_FRAMEWORK_VERSION \
  robotframework-faker==$FAKER_VERSION \
  robotframework-pabot==$PABOT_VERSION \
  robotframework-seleniumlibrary==$SELENIUM_LIBRARY_VERSION \
  robotframework-requests==$REQUESTS_VERSION

# Prepare requirment package
COPY ./requirements.txt /opt/robotframework

# Install Script Packages
RUN pip3 install -r /opt/robotframework/requirements.txt


# Download Gecko drivers directly from the GitHub repository
RUN wget -q "https://github.com/mozilla/geckodriver/releases/download/$GECKO_DRIVER_VERSION/geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz" \
      && tar xzf geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz \
      && mkdir -p /opt/robotframework/drivers/ \
      && mv geckodriver /opt/robotframework/drivers/geckodriver \
      && rm geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz

# Prepare binaries to be executed
COPY bin/chromedriver.sh /opt/robotframework/bin/chromedriver
COPY bin/run-tests-in-virtual-screen.sh /opt/robotframework/bin/

# Update system path
ENV PATH=/opt/robotframework/bin:/opt/robotframework/drivers:$PATH

# Execute all robot tests
CMD ["run-tests-in-virtual-screen.sh"]
