blobs = db.blobs.find({}, {hash: 1}).toArray();

db.users.insertMany([
  { login: "piotr",    name: "Piotr",    gender: "m", age: 27, image_hash: blobs[25].hash, description: "Dobry chłop."}, 
  { login: "ania",     name: "Ania",     gender: "f", age: 32, image_hash: blobs[8].hash , description: "Uwielbiam długie spacery po mieście, dobre jedzenie i spontaniczne wyjazdy. Szukam kogoś, kto potrafi śmiać się z siebie i ma pasję do życia."}, 
  { login: "julia",    name: "Julia",    gender: "f", age: 24, image_hash: blobs[9].hash , description: "Introvert na misji ośmielenia się do świata. Kawa, kino, koncerty alternatywne. Jeśli znasz fajne miejsce na chill, prowadź! "}, 
  { login: "zosia",    name: "Zosia",    gender: "f", age: 28, image_hash: blobs[12].hash, description: "Kocham sztukę, podróże i rozmowy do późna. Szukam kogoś, kto chce budować coś więcej niż kolejną kolekcję „matchy”."}, 
  { login: "wiktoria", name: "Wiktoria", gender: "f", age: 21, image_hash: blobs[22].hash, description: "Studentka, miłośniczka memów, kotów i dobrej pizzy. Chcę kogoś, z kim będzie śmiesznie, a nie tylko ładnie na zdjęciach."}, 
  { login: "kinga",    name: "Kinga",    gender: "f", age: 30, image_hash: blobs[29].hash, description: "Fanka aktywnego życia, natury i brunchy w weekend. Szukam partnera do wspólnych wypadów, sportów i głupich żartów."}, 
  // { login: "silska",      name: "Lucyna Silska",       gender: "f", image_hash: blobs[19].hash}, 
  // { login: "pylypenko",   name: "Lucyna Pylypenko",    gender: "f", image_hash: blobs[21].hash}, 
  // { login: "pogodzinska", name: "Agata Pogodzińska",   gender: "f", image_hash: blobs[22].hash}, 
  // { login: "lukowicz",    name: "Mariia Łukowicz",     gender: "f", image_hash: blobs[24].hash}, 
  // { login: "zacharczuk",  name: "Wanda Zacharczuk",    gender: "f", image_hash: blobs[26].hash}, 
  // { login: "zwolinski",   name: "Rafał Zwoliński",     gender: "m", image_hash: blobs[1].hash}, 
  // { login: "roslon",      name: "Seweryn Rosłon",      gender: "m", image_hash: blobs[4].hash}, 
  // { login: "płaczek",     name: "Bogusław Płaczek",    gender: "m", image_hash: blobs[5].hash}, 
  // { login: "pol",         name: "Stefan Pol",          gender: "m", image_hash: blobs[7].hash}, 
  // { login: "jakubaszek",  name: "Marian Jakubaszek",   gender: "m", image_hash: blobs[8].hash}, 
  // { login: "gasiorek",    name: "Dominik Gąsiorek",    gender: "m", image_hash: blobs[9].hash}, 
  // { login: "kunka",       name: "Julian Kunka",        gender: "m", image_hash: blobs[10].hash}, 
  // { login: "kaja",        name: "Edward Kaja",         gender: "m", image_hash: blobs[11].hash}, 
  // { login: "wojtaszczyk", name: "Marek Wojtaszczyk",   gender: "m", image_hash: blobs[12].hash}, 
  // { login: "wosiak",      name: "Bogumił Wosiak",      gender: "m", image_hash: blobs[13].hash}, 
  // { login: "dabkowski",   name: "Maksym Dąbkowski",    gender: "m", image_hash: blobs[14].hash}, 
  // { login: "gumkowski",   name: "Ignacy Gumkowski",    gender: "m", image_hash: blobs[16].hash}, 
  // { login: "pupek",       name: "Fryderyk Pupek",      gender: "m", image_hash: blobs[18].hash}, 
  // { login: "sielski",     name: "Mieczysław Sielski",  gender: "m", image_hash: blobs[20].hash}, 
  // { login: "kusmierski",  name: "Maciej Kuśmierski",   gender: "m", image_hash: blobs[23].hash}, 
  // { login: "mozdzen",     name: "Jarosław Możdżeń",    gender: "m", image_hash: blobs[25].hash}, 
  // { login: "grzelak",     name: "Karol Grzelak",       gender: "m", image_hash: blobs[27].hash}, 
  // { login: "wietrzynski", name: "Mariusz Wietrzyński", gender: "m", image_hash: blobs[28].hash},
  // { login: "kotecki",     name: "Bogumił Kotecki",     gender: "m", image_hash: blobs[29].hash}, 
]);


db.user_links.insertMany([
  {"login_1": "piotr", "login_2": "ania", "approved_1": undefined, "approved_2": true},
  {"login_1": "piotr", "login_2": "julia", "approved_1": undefined, "approved_2": true},
])
