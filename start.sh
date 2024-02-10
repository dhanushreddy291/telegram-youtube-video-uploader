#!/bin/sh

# Start the cron service
crond

# Start the Telegram Bot server in the foreground
exec /usr/local/bin/telegram-bot-api --api-id=$API_ID --api-hash=$API_HASH --http-port=8080 --local
