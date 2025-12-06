from __future__ import annotations

from typing import Annotated, TypedDict

from fastapi import APIRouter, Depends
from pymongo.database import Collection

from app.db import Db, get_db

router = APIRouter(tags=["users"])


class User(TypedDict):
    login: str
    name: str


def get_user_db(db: Annotated[Db, Depends(get_db)]) -> Collection[User]:
    return db["users"]


@router.get("/users/")
async def read_users(
    users: Annotated[Collection[User], Depends(get_user_db)],
) -> list[User]:
    return [*users.find()]
