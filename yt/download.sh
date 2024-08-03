#!/bin/sh
export PYTHONPATH="${PYTHONPATH}:/yt/"
VID_URL="$1"
VID_TITLE=$(yt-dlp --get-title "$VID_URL")

# Escape single quotes within the video title
VID_TITLE_ESCAPED=$(printf "%s" "$VID_TITLE" | sed "s/'/\\\\'/g")
# Escape double quotes within the video title
VID_TITLE_ESCAPED=$(printf "%s" "$VID_TITLE_ESCAPED" | sed 's/"/\\"/g')

# Properly quote variables in COMMAND_TO_EXECUTE
COMMAND_TO_EXECUTE="yt-dlp -f 'bestvideo[height<=1080]+bestaudio/best[height<=1080]' -o \"${VID_TITLE_ESCAPED}.mp4\" --merge-output-format mp4 \"$VID_URL\""

# Check the environment variable if IS_AUDIO_ONLY is set then download the audio only
if [ "$IS_AUDIO_ONLY" = "true" ]; then
    COMMAND_TO_EXECUTE="yt-dlp -x --audio-format mp3 -f 'bestaudio/best' -o \"${VID_TITLE_ESCAPED}.mp3\" \"$VID_URL\""
fi

# Execute the command
eval "$COMMAND_TO_EXECUTE" || exit 1


echo "Starting the bot server"

# Start the bot server in the background
/usr/local/bin/telegram-bot-api --local --http-port 3002 --api-id "$API_ID" --api-hash "$API_HASH" &

echo "Bot server started"

# Wait for the server to start
while ! curl -s http://localhost:3002 > /dev/null; do
    sleep 0.1 # wait for 1/10 of the second before check again
    echo "Waiting for the bot server to start..."
done


# Send a CURL request to the bot with the video
if [ "$IS_AUDIO_ONLY" = "true" ]; then
    # Escape single quotes within the video title
    VID_TITLE_ESCAPED=$(printf "%s" "$VID_TITLE" | sed "s/'/\\\\'/g")
    # Escape double quotes within the video title
    VID_TITLE_ESCAPED=$(printf "%s" "$VID_TITLE_ESCAPED" | sed 's/"/\\"/g')
    echo "Sending audio to the bot"
    CURL_COMMAND_TO_EXECUTE="curl --location \"http://localhost:3002/bot${BOT_TOKEN}/sendAudio?chat_id=${CHAT_ID}\" --form \"audio=@\\\"${VID_TITLE_ESCAPED}.mp3\\\"\""
else
    # Escape single quotes within the video title
    VID_TITLE_ESCAPED=$(printf "%s" "$VID_TITLE" | sed "s/'/\\\\'/g")
    # Escape double quotes within the video title
    VID_TITLE_ESCAPED=$(printf "%s" "$VID_TITLE_ESCAPED" | sed 's/"/\\"/g')
    echo "Sending video to the bot"
    CURL_COMMAND_TO_EXECUTE="curl --location \"http://localhost:3002/bot${BOT_TOKEN}/sendVideo?chat_id=${CHAT_ID}\" --form \"video=@\\\"${VID_TITLE_ESCAPED}.mp4\\\"\""
fi

eval "$CURL_COMMAND_TO_EXECUTE" || exit 1

echo "Task completed successfully"
