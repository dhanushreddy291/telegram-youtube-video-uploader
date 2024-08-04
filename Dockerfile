# Stage 1: Build Stage
FROM dhanushreddy29/telegram-youtube-video-uploader:latest as base

# Stage 2: Final Image
FROM python:3.10.13-alpine

LABEL maintainer="dhanushreddy291@yahoo.com"

# Copy the telegram-bot-api binary from the base image
COPY --from=base /usr/local/bin/telegram-bot-api* /usr/local/bin/

RUN apk update && apk upgrade && apk --no-cache add curl ffmpeg build-base
RUN pip install --upgrade pip "yt-dlp[default]"

# Copy files from yt directory to the root directory of the Docker image
COPY yt/ yt/

# Entry point is download.sh script
ENTRYPOINT ["/bin/sh", "/yt/download.sh"]
CMD []
