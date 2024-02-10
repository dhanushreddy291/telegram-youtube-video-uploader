#!/bin/sh
export PYTHONPATH="/usr/bin/python:/data/telegram-youtube-video-uploader/yt/"
VID_URL=$1
VID_TITLE=$(python -m youtube_dl --get-title "$VID_URL" | sed 's/[/\:*?"<>|]/_/g')
python -m youtube_dl -f 'bestvideo[height<=1080]+bestaudio/best[height<=1080]' -o "${VID_TITLE}.mp4" --merge-output-format mp4 "$VID_URL" || exit 1

# Send a CURL request to the bot with the video
curl --location "http://localhost:8080/bot${BOT_TOKEN}/sendVideo?chat_id=${CHAT_ID}" --form "video=@\"${VID_TITLE}.mp4\"" || exit 1

rm "${VID_TITLE}.mp4"