# Pull base image
FROM java:8-jre-alpine

# Set environment variables
ENV SUBSONIC_HOME="/var/subsonic"
ENV SUBSONIC_DATA="${SUBSONIC_HOME}/data"
ARG SUBSONIC_VERSION="6.0"
ARG SUBSONIC_TRANSCODERS="ffmpeg flac lame"

#
COPY start.sh /tmp/start.sh

# Install subsonic
RUN apk --no-cache add $SUBSONIC_TRANSCODERS && \
        addgroup -S -g 500 subsonic && \
        adduser -S -h $SUBSONIC_HOME -u 500 -G subsonic subsonic && \
        wget http://subsonic.org/download/subsonic-${SUBSONIC_VERSION}-standalone.tar.gz -O - | tar zxf - -C /tmp && \
        install -o subsonic -g subsonic -m 0755 -d $SUBSONIC_HOME/transcode && \
        install -o subsonic -g subsonic -m 0644 /tmp/* $SUBSONIC_HOME && \
        sed -i "s! > \${LOG} 2>&1 &!!" $SUBSONIC_HOME/subsonic.sh && \
        for transcoder in $SUBSONIC_TRANSCODERS; do ln -s "$(which $transcoder)" $SUBSONIC_HOME/transcode; done && \
        rm -f /tmp/*

# Define mountable directories
VOLUME ["$SUBSONIC_DATA"]

# Define default user
USER subsonic

# Define working directory
WORKDIR $SUBSONIC_HOME

# Define default command
CMD ["/bin/sh", "./start.sh"]

# Expose ports
EXPOSE 4040
