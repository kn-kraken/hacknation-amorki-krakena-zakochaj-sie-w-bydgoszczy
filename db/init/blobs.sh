#!/bin/sh

blobs=""
for blob in /docker-entrypoint-initdb.d/blobs/01.jpeg; do
  b64="$(base64 -w0 <"$blob")"
  cmd="{name: '$blob', data: '$b64'},"
  blobs="$blobs$cmd"
done

echo "db.blobs.insertMany([$blobs])" >/tmp/blobscript.js
mongosh "mongodb://localhost/$MONGO_INITDB_DATABASE" /tmp/blobscript.js
rm /tmp/blobscript.js
