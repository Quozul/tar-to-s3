#!/bin/bash

# Arguments:
export BUCKET_NAME=$1
tape_length=$2 # Tape length for the archive
archive_name=$3 # Name of the archive to create
destination=$4 # Source directory or file to archive

# Check if arguments are provided
if [ -z "$tape_length" ] || [ -z "$archive_name" ] || [ -z "$destination" ]; then
    echo "Usage: $0 <bucket-name> <tape-length> <archive-name> <destination>"
    exit 1
fi

temp_last=$(mktemp)
trap 'rm -rf -- "$temp_last"' EXIT
export LAST=$temp_last

# 1. Download the first archive to a temp directory
TAR_SUBCOMMAND=-x TAR_ARCHIVE="$archive_name" ./new-volume

# 2. Start extracting
# The new-volume-script will fetch the next archives and delete the previous extracted one

tar --extract --tape-length $tape_length --file $archive_name --new-volume-script ./new-volume --directory $destination

# 3. Delete the last archive
rm -f $(cat $LAST)
