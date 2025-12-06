blobs = db.blobs.find({}, {hash: 1}).toArray();

db.users.insertMany([
  {
    login: "jkow",
    name: "Jan Kowalski",
    image_hash: blobs[0].hash,
  },
  {
    login: "kjan",
    name: "Kowal Jański",
    image_hash: blobs[1].hash,
  },
]);
