#!/bin/bash

# Arguments:
export BUCKET_NAME=$1
tape_length=$2 # Tape length for the archive
archive_name=$3 # Name of the archive to create
source=$4 # Source directory or file to archive

# Check if arguments are provided
if [ -z "$tape_length" ] || [ -z "$archive_name" ] || [ -z "$source" ]; then
    echo "Usage: $0 <bucket-name> <tape-length> <archive-name> <source>"
    exit 1
fi

# Create a temp directory to store the archive
temp_dir=$(mktemp -d)
trap 'rm -rf -- "$temp_dir"' EXIT
temp_last=$(mktemp)
trap 'rm -rf -- "$temp_last"' EXIT
export LAST=$temp_last

# 1. Start creating the archive
# The new-volume-script will upload the archive to an S3 bucket then delete it
tar --create --tape-length $tape_length --file "$temp_dir/$archive_name" --new-volume-script ./new-volume $source

# 2. Upload the last file
TAR_SUBCOMMAND=-c TAR_ARCHIVE=$(cat $LAST) ./new-volume
