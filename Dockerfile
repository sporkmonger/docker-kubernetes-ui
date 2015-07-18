FROM quay.io/sporkmonger/confd:latest
MAINTAINER Bob Aman <bob@sporkmonger.com>

ENV VERSION=v1.0.0

# Install NodeJS & dependencies
RUN apk add --update git nodejs && \
  rm -rf /var/cache/apk/*

# Add confd files
# COPY ./nginx.conf.tmpl /etc/confd/templates/nginx.conf.tmpl
# COPY ./nginx.toml /etc/confd/conf.d/nginx.toml

# Get a copy of the Kubernetes UI app.
RUN mkdir -p /opt/src && \
  git clone -b $VERSION \
    https://github.com/GoogleCloudPlatform/kubernetes.git \
    /opt/src/kubernetes && \
  cd /opt/src/kubernetes/www/master && \
  npm install && \
  cd - > /dev/null

RUN mkdir -p /srv/www

# Add boot script
RUN chmod a+x /opt/bin/confd

# Make sure everything is up-to-date
RUN /opt/bin/cveck

EXPOSE 8080

# Run the boot script
CMD /bin/bash

# Derivative images should have:
# RUN cd /opt/src && make && make install && make clean && cd -
