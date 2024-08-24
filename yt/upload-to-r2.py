import os
import sys

import boto3


def upload_file(file_name, bucket):
    object_name = file_name
    ACCOUNT_ID = os.getenv("CLOUDFLARE_ACCOUNT_ID")
    s3_client = boto3.client(
        "s3", endpoint_url=f"https://{ACCOUNT_ID}.r2.cloudflarestorage.com"
    )

    response = s3_client.upload_file(file_name, bucket, object_name)
    return response


if __name__ == "__main__":
    fileName = sys.argv[1]
    BUCKET_NAME = os.getenv("BUCKET_NAME")
    upload_file(fileName, BUCKET_NAME)
