db = db.getSiblingDB("bydgoszcz");

db.users.insertMany([
  {
    login: "jkow",
    name: "Jan Kowalski",
  },
  {
    login: "kjan",
    name: "Kowal Jański",
  },
]);
