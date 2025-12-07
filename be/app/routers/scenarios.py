from __future__ import annotations

from typing import Annotated, Literal, TypedDict

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from pymongo.database import Collection

from app.db import Db, get_db

router = APIRouter(tags=["scenarios"])


class Scenario(TypedDict):
    id: int
    title: str
    description: str
    steps: list[Step]


StepType = Literal["question"] | Literal["task"]


class Question(TypedDict):
    id: int
    type: Literal["question"]
    lat: float
    long: float
    question: str
    answers: list[str]
    validAnswerIndex: int
    curiocity: str


class Task(TypedDict):
    id: int
    type: Literal["task"]
    lat: float
    long: float
    task: str
    curiocity: str


Step = Question | Task


class ScenarioInfoRes(BaseModel):
    id: int
    title: str
    description: str

    @classmethod
    def from_domain(cls, scenario: Scenario):
        return cls(
            id=scenario["id"],
            title=scenario["title"],
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
) -> list[ScenarioInfoRes]:
    return [ScenarioInfoRes.from_domain(scenario) for scenario in scenarios.find()]


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
) -> Step:
    scenario = scenarios.find_one({"id": id})
    if scenario is None:
        raise HTTPException(status_code=404, detail="Not found")

    match [step for step in scenario["steps"] if step["id"] == step_id]:
        case [step]:
            return step
        case _:
            raise HTTPException(status_code=404, detail="Not found")
