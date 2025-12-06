from collections.abc import Iterable
from typing import Any

from pymongo import MongoClient
from pymongo.database import Database

from app.settings import settings

Db = Database[Any]  # pyright: ignore[reportExplicitAny]


def get_db() -> Iterable[Db]:
    connection_string = settings.connection_string
    client = MongoClient[Any](connection_string)  # pyright: ignore[reportExplicitAny]
    yield client.get_default_database()
    client.close()
