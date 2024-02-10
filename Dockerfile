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

LABEL maintainer="dhanushreddy291@yahoo.com"

# Copy only the necessary files from the build stage
COPY --from=builder /usr/local/bin/telegram-bot-api* /usr/local/bin/

# Make it executable
RUN chmod +x /usr/local/bin/telegram-bot-api

RUN apk update && apk upgrade && apk add curl ffmpeg

# Upgrade pip and install required Python packages
RUN pip install --upgrade pip && \
    pip install requests

COPY yt/ yt/
COPY poll.py /usr/home/poll.py
COPY start.sh /start.sh

# Make scripts and bot API executable
RUN chmod +x /usr/local/bin/telegram-bot-api && \
    chmod +x yt/audio.sh && \
    chmod +x yt/video.sh && \
    chmod +x /usr/home/poll.py && \
    chmod +x /start.sh && \
    echo '* * * * * /usr/local/bin/python /usr/home/poll.py > /var/log/cron.log 2>&1' > /etc/crontabs/root

# Expose the necessary port
EXPOSE 8080

# Set the entry point to the start script
CMD ["/start.sh"]
