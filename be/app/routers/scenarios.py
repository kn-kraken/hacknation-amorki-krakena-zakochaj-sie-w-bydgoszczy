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
    steps: list[Question | Task]


StepType = Literal["question"] | Literal["task"]


class Question(TypedDict):
    type: Literal["question"]
    question: str
    answers: list[str]
    validAnswerIndex: int
    curiocity: str


class Task(TypedDict):
    type: Literal["task"]
    task: str
    curiocity: str


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


def get_scenarios_db(db: Annotated[Db, Depends(get_db)]) -> Collection[Scenario]:
    return db["scenarios"]


@router.get("/scenarios/")
async def read_scenarios(
    scenarios: Annotated[Collection[Scenario], Depends(get_scenarios_db)],
) -> list[ScenarioInfoRes]:
    return [ScenarioInfoRes.from_domain(scenario) for scenario in scenarios.find()]


@router.get("/scenarios/{id}")
async def read_scenario(
    id: int,
    scenarios: Annotated[Collection[Scenario], Depends(get_scenarios_db)],
) -> Scenario:
    scenario = scenarios.find_one({"id": id})
    if scenario is None:
        raise HTTPException(status_code=404, detail="Not found")
    return scenario
