# Stage 1: Build Stage
FROM alpine:latest as builder

RUN apk update && \
    apk upgrade && \
    apk add --update alpine-sdk linux-headers git zlib-dev openssl-dev gperf cmake

WORKDIR /app

RUN git clone --recursive https://github.com/tdlib/telegram-bot-api.git
WORKDIR /app/telegram-bot-api

RUN rm -rf build && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local .. && \
    cmake --build . --target install

# Stage 2: Final Image
FROM python:3.10.13-alpine

# Copy only the necessary files from the build stage
COPY --from=builder /usr/local/bin/telegram-bot-api* /usr/local/bin/

RUN apk update && apk upgrade && apk --no-cache add curl ffmpeg
# Copy files from yt directory to the root directory of the Docker image
COPY yt/ yt/

# Entry point is download.sh script
ENTRYPOINT ["/bin/sh", "/yt/download.sh"]
CMD []

