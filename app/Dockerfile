FROM alpine:3.7

# Some ENV variables
ENV PATH="/mattermost/bin:${PATH}"
ENV MM_VERSION=5.8.0

# Build argument to set Mattermost edition
ARG edition=enterprise
ARG PUID=2000
ARG PGID=2000
ARG MM_BINARY=


# Install some needed packages
RUN apk add --no-cache \
	ca-certificates \
	curl \
	jq \
	libc6-compat \
	libffi-dev \
	linux-headers \
	mailcap \
	netcat-openbsd \
	xmlsec-dev \
	&& rm -rf /tmp/*

# Get Mattermost
RUN mkdir -p /mattermost/data /mattermost/plugins /mattermost/client/plugins \
    && if [ ! -z "$MM_BINARY" ]; then curl $MM_BINARY | tar -xvz ; \
      elif [ "$edition" = "team" ] ; then curl https://releases.mattermost.com/$MM_VERSION/mattermost-team-$MM_VERSION-linux-amd64.tar.gz | tar -xvz ; \
      else curl https://releases.mattermost.com/$MM_VERSION/mattermost-$MM_VERSION-linux-amd64.tar.gz | tar -xvz ; fi \
    && cp /mattermost/config/config.json /config.json.save \
    && rm -rf /mattermost/config/config.json \
    && addgroup -g ${PGID} mattermost \
    && adduser -D -u ${PUID} -G mattermost -h /mattermost -D mattermost \
    && chown -R mattermost:mattermost /mattermost /config.json.save /mattermost/plugins /mattermost/client/plugins

COPY ./consult.crt /usr/local/share/ca-certificates/consult.crt
RUN update-ca-certificates

USER mattermost

#Healthcheck to make sure container is ready
HEALTHCHECK CMD curl --fail http://localhost:8000 || exit 1

# Configure entrypoint and command
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
WORKDIR /mattermost
CMD ["mattermost"]

# Expose port 8000 of the container
EXPOSE 8000

# Declare volumes for mount point directories
VOLUME ["/mattermost/data", "/mattermost/logs", "/mattermost/config", "/mattermost/plugins", "/mattermost/client/plugins"]
