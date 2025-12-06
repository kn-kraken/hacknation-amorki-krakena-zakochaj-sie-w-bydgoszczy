from collections.abc import Iterable
from typing import Any

from pymongo import MongoClient
from pymongo.database import Database

Db = Database[Any]  # pyright: ignore[reportExplicitAny]


def get_db() -> Iterable[Db]:
    CONNECTION_STRING = (
        "mongodb://admin:password@localhost:27017/bydgoszcz?authSource=admin"
    )
    client = MongoClient[Any](CONNECTION_STRING)  # pyright: ignore[reportExplicitAny]
    yield client.get_default_database()
    client.close()
