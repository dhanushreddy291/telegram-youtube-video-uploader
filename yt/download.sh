#!/bin/sh
export PYTHONPATH="${PYTHONPATH}:/yt/"
VID_URL=$1
VID_TITLE=$(python -m youtube_dl --get-title "$VID_URL" | sed 's/[/\:*?"<>|]/_/g')
python -m youtube_dl -f 'bestvideo[height<=1080]+bestaudio/best[height<=1080]' -o "${VID_TITLE}.mp4" --merge-output-format mp4 "$VID_URL" || exit 1

# Start the bot server in the background
/usr/local/bin/telegram-bot-api --local --http-port 3000 --api-id $API_ID --api-hash $API_HASH &

# Wait for the server to start
while ! nc -z localhost 3000; do   
    sleep 0.1 # wait for 1/10 of the second before check again
done

# Send a CURL request to the bot with the video
curl --location "http://localhost:3000/bot${BOT_TOKEN}/sendVideo?chat_id=975596313" --form "video=@\"${VID_TITLE}.mp4\"" || exit 1
