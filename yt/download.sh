#!/bin/sh
export PYTHONPATH="${PYTHONPATH}:/yt/"
VID_URL="$1"
VID_TITLE=$(python -m youtube_dl --get-title "$VID_URL")

# Properly quote variables in COMMAND_TO_EXECUTE
COMMAND_TO_EXECUTE="python -m youtube_dl -f 'bestvideo[height<=1080]+bestaudio/best[height<=1080]' -o '${VID_TITLE}.mp4' --merge-output-format mp4 '$VID_URL'"

# Check the environment variable if IS_AUDIO_ONLY is set then download the audio only
if [ "$IS_AUDIO_ONLY" = "true" ]; then
    COMMAND_TO_EXECUTE="python -m youtube_dl -x --audio-format mp3 -f 'bestaudio/best' -o '${VID_TITLE}.mp3' '$VID_URL'"
fi

# Execute the command
eval "$COMMAND_TO_EXECUTE" || exit 1

# Start the bot server in the background
/usr/local/bin/telegram-bot-api --local --http-port 3000 --api-id "$API_ID" --api-hash "$API_HASH" &

# Wait for the server to start
while ! nc -z localhost 3000; do   
    sleep 0.1 # wait for 1/10 of the second before check again
done

# Send a CURL request to the bot with the video
if [ "$IS_AUDIO_ONLY" = "true" ]; then
    CURL_COMMAND_TO_EXECUTE="curl --location 'http://localhost:3000/bot${BOT_TOKEN}/sendAudio?chat_id=${CHAT_ID}' --form 'audio=@\"${VID_TITLE}.mp3\"'"
else
    CURL_COMMAND_TO_EXECUTE="curl --location 'http://localhost:3000/bot${BOT_TOKEN}/sendVideo?chat_id=${CHAT_ID}' --form 'video=@\"${VID_TITLE}.mp4\"'"
fi

eval "$CURL_COMMAND_TO_EXECUTE" || exit 1
