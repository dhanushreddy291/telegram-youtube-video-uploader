A simple docker image to download a youtube video at 1080p resolution and best audio and merge together using `youtube_dl` and send it over to you on Telegram.

Supports videos upto 2 GB in size.

# Get API_ID and API_HASH here:
[https://my.telegram.org/apps](https://my.telegram.org/apps)

# Get your telegram chat id using this bot
[https://t.me/JsonBot](https://t.me/JsonBot)

# Run the prebuilt Docker Image:
```bash
docker run --rm -e API_ID=YOUR_API_ID -e API_HASH=YOUR_API_HASH -e BOT_TOKEN=TELEGRAM_BOT_TOKEN -e CHAT_ID=YOUR_CHAT_ID dhanushreddy29/telegram-youtube-video-uploader YOUTUBE_VIDEO_LINK
```

and get the video directly in your telegram DM

## Note:
You must message your bot atleast once to get any messages from it. So do that first.
Also `logOut` from the webhook of telegram if you have setup any using this link `https://api.telegram.org/bot[YOUR_BOT_TOKEN]/logOut`

## Learn More:
[https://core.telegram.org/bots/api#using-a-local-bot-api-server](https://core.telegram.org/bots/api#using-a-local-bot-api-server)

## Repo Link
Feel free to raise a PR here:
[https://github.com/dhanushreddy291/telegram-youtube-video-uploader](https://github.com/dhanushreddy291/telegram-youtube-video-uploader)