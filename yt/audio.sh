#!/bin/sh
export PYTHONPATH="/usr/bin/python:/yt/"
VID_URL=$1
VID_TITLE=$(python -m youtube_dl --get-title "$VID_URL" | sed 's/[/\:*?"<>|]/_/g')
python -m youtube_dl -x --audio-format mp3 -f 'bestaudio/best' -o "${VID_TITLE}.mp3" "$VID_URL" || exit 1

# Send a CURL request to the bot with the video
curl --location "http://localhost:8080/bot${BOT_TOKEN}/sendAudio?chat_id=${CHAT_ID}" --form "audio=@\"${VID_TITLE}.mp3\"" || exit 1

rm "${VID_TITLE}.mp3"