from __future__ import annotations

from typing import Annotated, TypedDict

from fastapi import APIRouter, Depends
from pydantic import BaseModel
from pymongo.database import Collection

from app.db import Db, get_db

router = APIRouter(tags=["users"])


class User(TypedDict):
    login: str
    name: str
    image_hash: str


class UserRes(BaseModel):
    login: str
    name: str
    image_url: str

    @classmethod
    def from_domain(cls, user: User) -> UserRes:
        return cls(
            login=user["login"],
            name=user["name"],
            image_url=f"/blobs/{user[ "image_hash" ]}",
        )


def get_user_db(db: Annotated[Db, Depends(get_db)]) -> Collection[User]:
    return db["users"]


@router.get("/users/")
async def read_users(
    users: Annotated[Collection[User], Depends(get_user_db)],
) -> list[UserRes]:
    return [UserRes.from_domain(user) for user in users.find()]
