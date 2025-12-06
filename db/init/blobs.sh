#!/bin/sh

blobs=""
for blob in /docker-entrypoint-initdb.d/blobs/*.jpeg; do
  b64="$(base64 -w0 <"$blob")"
  hash=$(echo $b64 | md5sum | cut -d ' ' -f 1)
  cmd="{hash: '$hash', data: '$b64'},"
  blobs="$blobs$cmd"
done

echo "db.blobs.insertMany([$blobs])" >/tmp/blobscript.js
mongosh "mongodb://localhost/$MONGO_INITDB_DATABASE" /tmp/blobscript.js
rm /tmp/blobscript.js
