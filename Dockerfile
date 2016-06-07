# Pull base image
FROM java:8-jre-alpine

ARG SUBSONIC_HOME=/var/subsonic
ARG SUBSONIC_DATA=$SUBSONIC_HOME/data
ARG SUBSONIC_VERSION=6.0
ARG SUBSONIC_TRANSCODERS="ffmpeg flac lame"
ARG SUBSONIC_USER=subsonic

# Install subsonic
RUN apk --no-cache add $SUBSONIC_TRANSCODERS && \
        adduser -S -h $SUBSONIC_HOME -u 1000 subsonic && \
        wget http://subsonic.org/download/subsonic-${SUBSONIC_VERSION}-standalone.tar.gz -O - | tar zxf - -C /tmp && \
        install -o subsonic -g nogroup -m 0755 \
            -d $SUBSONIC_HOME/transcode        \
            -d $SUBSONIC_DATA                  \
            -d $SUBSONIC_DATA/music            \
            -d $SUBSONIC_DATA/music/podcast    \
            -d $SUBSONIC_DATA/playlists     && \
        install -o subsonic -g nogroup -m 0644 /tmp/* $SUBSONIC_HOME && \
        install -o subsonic -g nogroup -m 0755 /tmp/subsonic.sh $SUBSONIC_HOME && \
        sed -i "s!^\(SUBSONIC_HOME=\).*!\1${SUBSONIC_HOME}!" $SUBSONIC_HOME/subsonic.sh && \
        sed -i "s!^\(SUBSONIC_DEFAULT_MUSIC_FOLDER=\).*!\1${SUBSONIC_DATA}/music!" $SUBSONIC_HOME/subsonic.sh && \
        sed -i "s!^\(SUBSONIC_DEFAULT_PODCAST_FOLDER=\).*!\1${SUBSONIC_DATA}/music\/podcast!" $SUBSONIC_HOME/subsonic.sh && \
        sed -i "s!^\(SUBSONIC_DEFAULT_PLAYLIST_FOLDER=\).*!\1${SUBSONIC_DATA}/playlists!" $SUBSONIC_HOME/subsonic.sh && \
        sed -i "s! > \${LOG} 2>&1 &!!" $SUBSONIC_HOME/subsonic.sh && \
        for transcoder in $SUBSONIC_TRANSCODERS; do ln -s "$(which $transcoder)" $SUBSONIC_HOME/transcode; done && \
        rm -f /tmp/*

# Define mountable directories
VOLUME ["$SUBSONIC_DATA"]

# Define user
USER $SUBSONIC_USER

# Define working directory
WORKDIR $SUBSONIC_HOME

# Define default command
CMD ["./subsonic.sh"]

# Expose ports
EXPOSE 4040
