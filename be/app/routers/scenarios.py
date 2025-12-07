from __future__ import annotations

from typing import Annotated, Literal, TypedDict

from fastapi import APIRouter, Depends, HTTPException, Request
from fastapi.datastructures import URL
from pydantic import BaseModel
from pymongo.database import Collection

from app.db import Db, get_db

router = APIRouter(tags=["scenarios"])


class Scenario(TypedDict):
    id: int
    title: str
    image_hash: str
    description: str
    steps: list[Step]


StepType = Literal["question"] | Literal["task"]


class Question(TypedDict):
    id: int
    type: Literal["question"]
    lat: float
    long: float
    image_hash: str
    question: str
    answers: list[str]
    validAnswerIndex: int
    curiocity: str


class Task(TypedDict):
    id: int
    type: Literal["task"]
    lat: float
    long: float
    image_hash: str
    task: str
    curiocity: str


Step = Question | Task


class QuestionRes(TypedDict):
    id: int
    type: Literal["question"]
    lat: float
    long: float
    image_url: str
    question: str
    answers: list[str]
    validAnswerIndex: int
    curiocity: str


class TaskRes(TypedDict):
    id: int
    type: Literal["task"]
    lat: float
    long: float
    image_url: str
    task: str
    curiocity: str


StepRes = QuestionRes | TaskRes


def step_to_res(step: Step, base_url: URL) -> StepRes:
    return step | {
        "image_url": f"{base_url}blobs/{step['image_hash']}"
    }  # pyright: ignore[reportReturnType]


class ScenarioInfoRes(BaseModel):
    id: int
    title: str
    image_url: str
    description: str

    @classmethod
    def from_domain(cls, scenario: Scenario, base_url: URL):
        return cls(
            id=scenario["id"],
            title=scenario["title"],
            image_url=f"{base_url}blobs/{scenario['image_hash']}",
            description=scenario["description"],
        )


class StepInfoRes(BaseModel):
    id: int
    lat: float
    long: float

    @classmethod
    def from_domain(cls, step: Step):
        return cls(
            id=step["id"],
            lat=step["lat"],
            long=step["long"],
        )


def get_scenarios_db(db: Annotated[Db, Depends(get_db)]) -> Collection[Scenario]:
    return db["scenarios"]


@router.get("/scenarios/")
async def read_scenarios(
    scenarios: Annotated[Collection[Scenario], Depends(get_scenarios_db)],
    request: Request,
) -> list[ScenarioInfoRes]:
    return [
        ScenarioInfoRes.from_domain(scenario, request.base_url)
        for scenario in scenarios.find()
    ]


@router.get("/scenarios/{id}/steps/")
async def read_scenario(
    id: int,
    scenarios: Annotated[Collection[Scenario], Depends(get_scenarios_db)],
) -> list[StepInfoRes]:
    scenario = scenarios.find_one({"id": id})
    if scenario is None:
        raise HTTPException(status_code=404, detail="Not found")
    return [StepInfoRes.from_domain(step) for step in scenario["steps"]]


@router.get("/scenarios/{id}/steps/{step_id}")
async def read_step(
    id: int,
    step_id: int,
    scenarios: Annotated[Collection[Scenario], Depends(get_scenarios_db)],
    request: Request,
) -> StepRes:
    scenario = scenarios.find_one({"id": id})
    if scenario is None:
        raise HTTPException(status_code=404, detail="Not found")

    match [step for step in scenario["steps"] if step["id"] == step_id]:
        case [step]:
            return step_to_res(step, request.base_url)
        case _:
            raise HTTPException(status_code=404, detail="Not found")
