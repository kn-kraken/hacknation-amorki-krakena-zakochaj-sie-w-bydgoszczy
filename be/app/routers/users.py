from __future__ import annotations

from typing import Annotated, TypedDict

from fastapi import APIRouter, Depends, Header, HTTPException, Request
from fastapi.datastructures import URL
from pydantic import BaseModel
from pymongo.database import Collection

from app.db import Db, get_db

router = APIRouter(tags=["users"])


class User(TypedDict):
    login: str
    name: str
    age: int
    description: str
    image_hash: str


class UserRes(BaseModel):
    login: str
    name: str
    age: int
    description: str
    image_url: str

    @classmethod
    def from_domain(cls, user: User, base_url: URL) -> UserRes:
        return cls(
            login=user["login"],
            name=user["name"],
            age=user["age"],
            description=user["description"],
            image_url=f"{base_url}blobs/{user["image_hash"]}",
        )


class UserLink(TypedDict):
    login_1: str
    login_2: str
    approved_1: bool | None
    approved_2: bool | None


def get_user_db(db: Annotated[Db, Depends(get_db)]) -> Collection[User]:
    return db["users"]


def get_user_link_db(db: Annotated[Db, Depends(get_db)]) -> Collection[UserLink]:
    return db["user_links"]


def get_me(
    x_login: Annotated[str, Header()],
    users: Annotated[Collection[User], Depends(get_user_db)],
) -> User:
    user = users.find_one({"login": x_login})
    if user == None:
        raise HTTPException(status_code=403, detail="Forbidden")
    return user


@router.get("/users/me")
async def read_me(
    me: Annotated[User, Depends(get_me)],
    request: Request,
) -> UserRes:
    return UserRes.from_domain(me, request.base_url)


@router.get("/users/next")
async def read_next(
    me: Annotated[User, Depends(get_me)],
    users: Annotated[Collection[User], Depends(get_user_db)],
    user_links: Annotated[Collection[UserLink], Depends(get_user_link_db)],
    request: Request,
) -> UserRes:
    my_login = me["login"]
    considered = user_links.find(
        {
            "$or": [
                {"login_1": my_login, "approved_1": {"$ne": None}},
                {"login_1": my_login, "approved_2": False},
                {"login_2": my_login, "approved_2": {"$ne": None}},
                {"login_2": my_login, "approved_1": False},
            ]
        }
    )
    considered_logins = [
        login for link in considered for login in [link["login_1"], link["login_2"]]
    ]
    considered_logins.append(my_login)
    filters = [{"login": {"$ne": login}} for login in considered_logins]
    if len(filters) > 0:
        unconsidered = users.aggregate(
            [{"$match": {"$and": filters}}, {"$sample": {"size": 1}}]
        )
    else:
        unconsidered = users.aggregate([{"$sample": {"size": 1}}])

    other = next(unconsidered, None)
    if other is None:
        reset_links(login=my_login, user_links=user_links)
        raise HTTPException(404, "Not found")

    return UserRes.from_domain(other, request.base_url)


def reset_links(
    login: str,
    user_links: Collection[UserLink],
):
    _ = user_links.update_many(
        {"login_1": login, "approved_1": {"$ne": None}},
        {"$set": {"approved_1": None}},
    )
    _ = user_links.update_many(
        {"login_2": login, "approved_2": {"$ne": None}},
        {"$set": {"approved_2": None}},
    )


@router.put("/users/{login}/swipe")
async def swipe(
    me: Annotated[User, Depends(get_me)],
    login: str,
    approved: bool,
    users: Annotated[Collection[User], Depends(get_user_db)],
    user_links: Annotated[Collection[UserLink], Depends(get_user_link_db)],
):
    other = users.find_one({"login": login})
    if other == None:
        raise HTTPException(status_code=404, detail="Not found")

    my_login = me["login"]
    other_login = other["login"]

    link_filter = {
        "$or": [
            {"login_1": my_login, "login_2": other_login},
            {"login_1": other_login, "login_2": my_login},
        ]
    }
    link = user_links.find_one(link_filter)
    if link is None:
        link = UserLink(
            {
                "login_1": my_login,
                "login_2": other["login"],
                "approved_1": None,
                "approved_2": None,
            }
        )

    if link["login_1"] == my_login:
        link["approved_1"] = approved
    else:
        link["approved_2"] = approved

    _ = user_links.update_one(link_filter, {"$set": link}, upsert=True)

    matched = all([link["approved_1"], link["approved_2"]])
    return SwipeRes(matched=matched)


class SwipeRes(BaseModel):
    matched: bool
