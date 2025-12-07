blobs = db.blobs.find({}, { hash: 1 }).toArray();

db.users.insertMany([
  {
    login: "piotr",
    name: "Piotr",
    gender: "m",
    age: 27,
    image_hash: blobs[25].hash,
    description: "Dobry chłop.",
  },
  {
    login: "ania",
    name: "Ania",
    gender: "f",
    age: 32,
    image_hash: blobs[8].hash,
    description:
      "Uwielbiam długie spacery po mieście, dobre jedzenie i spontaniczne wyjazdy. Szukam kogoś, kto potrafi śmiać się z siebie i ma pasję do życia.",
  },
  {
    login: "julia",
    name: "Julia",
    gender: "f",
    age: 24,
    image_hash: blobs[9].hash,
    description:
      "Introvert na misji ośmielenia się do świata. Kawa, kino, koncerty alternatywne. Jeśli znasz fajne miejsce na chill, prowadź! ",
  },
  {
    login: "zosia",
    name: "Zosia",
    gender: "f",
    age: 28,
    image_hash: blobs[12].hash,
    description:
      "Kocham sztukę, podróże i rozmowy do późna. Szukam kogoś, kto chce budować coś więcej niż kolejną kolekcję „matchy”.",
  },
  {
    login: "wiktoria",
    name: "Wiktoria",
    gender: "f",
    age: 21,
    image_hash: blobs[22].hash,
    description:
      "Studentka, miłośniczka memów, kotów i dobrej pizzy. Chcę kogoś, z kim będzie śmiesznie, a nie tylko ładnie na zdjęciach.",
  },
  {
    login: "kinga",
    name: "Kinga",
    gender: "f",
    age: 30,
    image_hash: blobs[29].hash,
    description:
      "Fanka aktywnego życia, natury i brunchy w weekend. Szukam partnera do wspólnych wypadów, sportów i głupich żartów.",
  },
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
  {
    login_1: "piotr",
    login_2: "ania",
    approved_1: undefined,
    approved_2: true,
  },
  {
    login_1: "piotr",
    login_2: "julia",
    approved_1: undefined,
    approved_2: true,
  },
]);

steps = [
  {
    id: 1,
    type: "question",
    lat: 53.123208,
    long: 18.001261,
    image_hash: blobs[30].hash,
    question:
      "Zaobserwuj rzeźbę przy moście. Zgadnij nazwę rzeźby, którą widzisz:",
    answers: ["Akrobata", "Przechodzący przez rzekę", "Dzień w chmurach"],
    validAnswerIndex: 1,
    curiocity:
      "Czy wiesz, że ta rzeźba to genialne zastosowanie fizyki? Środek ciężkości figury znajduje się poniżej liny, na której wisi. Dzięki temu „Przechodzący” utrzymuje równowagę sam z siebie i nie przewróci go nawet silny wiatr!",
  },
  {
    id: 2,
    type: "question",
    lat: 53.122973,
    long: 17.999429,
    image_hash: blobs[31].hash,
    question: "Katedra Bydgoska. Zgadnij rok budowy:",
    answers: ["1466", "1604", "1308"],
    validAnswerIndex: 0,
    curiocity:
      "Katedra jest najstarszym budynkiem w Bydgoszczy. W trakcie prac konserwatorskich prowadzonych w bydgoskiej katedrze archeolodzy odnaleźli prawdziwy skarb!",
  },
  {
    id: 3,
    type: "question",
    lat: 53.119686,
    long: 17.990881,
    image_hash: blobs[32].hash,
    question: "Wieża ciśnień. Zgadnij wysokość zabytku:",
    answers: ["21 m", "45 m", "32 m"],
    validAnswerIndex: 1,
    curiocity:
      "Kiedyś wewnątrz znajdował się gigantyczny zbiornik, który mieścił aż 1260 m³ wody – to tyle, co ok. 4000 pełnych wanien!",
  },
  {
    id: 4,
    type: "question",
    lat: 53.122926,
    long: 17.994599,
    image_hash: blobs[33].hash,
    question:
      "Wyspa Młyńska. Znajdź dom Dom Leona Wyczółkowskiego. W jakim stylu powstał ten dom?",
    answers: ["Gotyckim", "Neoromantycznym", "Romańskim"],
    validAnswerIndex: 1,
    curiocity:
      "Leon Wyczółkowski tak naprawdę... nigdy nie mieszkał w tym domu! Mieszkał w dworku w pobliskim Gościeradzu. Ten budynek na Wyspie Młyńskiej pełni funkcję muzeum, ponieważ artysta przed śmiercią przekazał miastu Bydgoszcz ogromną kolekcję swoich prac (obrazy, grafiki, meble).",
  },
  {
    id: 5,
    type: "task",
    lat: 53.123736,
    long: 17.998304,
    image_hash: blobs[35].hash,
    task: "Most Miłości Jana Kiepury. Zrób sobie wspólne zdjęcie.",
    curiocity:
      "Do wieszania swoich kłódek mieszkańcy upatrzyli sobie Most Kiepury prowadzący na Wyspę Młyńską, jednak z przyczyn technicznych kłódki te musiały zostać zdjęte. Powstała za to specjalnie na tę okazję przygotowana metalowa instalacja przy bulwarach.",
  },
  {
    id: 6,
    type: "task",
    lat: 53.126262,
    long: 18.004072,
    image_hash: blobs[37].hash,
    task: "Zapraszamy was na kawę. Polecana kawiarnia w okolicy to: Bromberg Kaffee – bydgoska palarnia kawy.",
    curiocity:
      "Nasze ziarna są wypalane metodą rzemieślniczą, w małych partiach. To pozwala nam kontrolować każdy etap i wydobyć pełnię smaku – głęboki, czysty profil, bez goryczy i przesadnej kwasowości.",
  },
];

db.scenarios.insertMany([
  {
    id: 1,
    title: "Miłość płynąca z Nurtem Brdy",
    description:
      "Pozwólcie, by nurt Brdy poprowadził Was przez najpiękniejsze zakątki historycznego centrum Bydgoszczy. Czekają na Was zagadki i piękne widoki.",
    steps: steps,
  },
  {
    id: 2,
    title: "Królewska Obietnica Kazimierza",
    description:
      "„Królewska Obietnica Kazimierza” to miejska trasa prowadząca przez kluczowe miejsca średniowiecznej Bydgoszczy, opowiadająca o nadaniu jej praw miejskich przez Kazimierza Wielkiego.",
    steps: steps,
  },
  {
    id: 3,
    title: "Szmaragdowy Tunel",
    description:
      "Zostawcie za sobą zgiełk miasta i wejdźcie do zielonego korytarza, gdzie czas zdaje się płynąć własnym, leniwym rytmem. Tutaj, w cieniu potężnych, stuletnich drzew, woda staje się lustrem dla historii.",
    steps: steps,
  },
]);
