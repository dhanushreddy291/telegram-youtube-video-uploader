import os
import requests
import subprocess

def poll():
    url = f'{os.environ.get("SUPABASE_URL")}?select=*'
    headers = {
        'apikey': os.environ.get("SUPABASE_KEY"),
        'Authorization': f'Bearer {os.environ.get("SUPABASE_KEY")}',
    }
    response = requests.get(url, headers=headers)
    videos = response.json()

    if len(videos) == 0:
        print("No videos to download")
        return

    for video in videos:
        if video["format"] == "mp3":
            print(f"Downloading Audio {video['link']}")
            response = subprocess.run(f"sh /yt/audio.sh {video['link']}", shell=True, capture_output=True)
        else:
            print(f"Downloading Video {video['link']}")
            response = subprocess.run(f"sh /yt/video.sh {video['link']}", shell=True, capture_output=True)

        # Delete the row again
        delete_url = f'{os.environ.get("SUPABASE_URL")}?id=eq.{video["id"]}'
        response = requests.delete(delete_url, headers=headers)

        # Delete all *.mp4, *.mp3 files
        subprocess.run("rm -f /yt/*.mp4", shell=True)
        subprocess.run("rm -f /yt/*.mp3", shell=True)

if __name__ == "__main__":
    poll()