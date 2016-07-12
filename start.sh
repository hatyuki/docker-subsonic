#!/bin/sh
SUBSONIC_MUSIC="${SUBSONIC_DATA}/music"
SUBSONIC_PODCAST="${SUBSONIC_DATA}/music/podcast"
SUBSONIC_PLAYLISTS="${SUBSONIC_DATA}/playlists"

for directory in $SUBSONIC_DATA $SUBSONIC_MUSIC $SUBSONIC_PODCAST $SUBSONIC_PLAYLISTS; do
    if [ ! -e $directory ]; then
        install -o subsonic -g subsonic -m 0750 -d $directory
    fi
done

sh ./subsonic.sh \
    --default-music-folder=$SUBSONIC_MUSIC \
    --default-podcast-folder=$SUBSONIC_PODCAST \
    --default-playlist-folder=$SUBSONIC_PLAYLISTS \
    --max-memory=${MAX_MEMORY:-'256'}
