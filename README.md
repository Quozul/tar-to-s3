# Tar-to-s3

A set of scripts to upload a multi-volume tar file to an AWS S3 bucket.
It is useful when you have to backup a large volume.

## Usage

```shell
❯ ./upload.sh your-s3-bucket-name 50m archive.tar /path/to/directory
```

```shell
❯ ./download.sh your-s3-bucket-name 50m archive.tar /path/to/directory
```
