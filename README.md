# Subsonic Dockerfile
This repository contains **Dockerfile** of [Subsonic](http://www.subsonic.org/) for [Docker](https://www.docker.com/)'s [automated build](https://registry.hub.docker.com/u/hatyuki/subsonic/)


## Base Docker Image
- [java:8-jre-alpine](https://hub.docker.com/_/java/)


## Usage

    docker run -d -p 4040:4040 hatyuki/subsonic

### Attach music directories

    docker run -d -p 4040:4040 -v <subsonic-music-dir>:/var/subsonic/data hatyuki/subsonic
