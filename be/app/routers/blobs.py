from base64 import b64decode
from typing import Annotated, TypedDict

from fastapi import APIRouter, Depends, HTTPException, Response
from pymongo.database import Collection

from app.db import Db, get_db

router = APIRouter(
    prefix="/blobs",
    tags=["blobs"],
    responses={404: {"description": "Not found"}},
)


class Blob(TypedDict):
    hash: str
    data: str


def get_blob_db(db: Annotated[Db, Depends(get_db)]) -> Collection[Blob]:
    return db["blobs"]


@router.get(
    "/{hash}", responses={200: {"content": {"image/jpeg": {}}}}, response_class=Response
)
async def read_blob(
    hash: str,
    blobs: Annotated[Collection[Blob], Depends(get_blob_db)],
):
    blob = blobs.find_one({"hash": hash})
    if blob is None:
        raise HTTPException(status_code=404, detail="Not found")
    base64 = blob["data"]
    bytes = b64decode(base64)
    return Response(content=bytes, media_type="image/jpeg")
