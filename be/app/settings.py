from pydantic.v1 import BaseSettings


class Settings(BaseSettings):
    connection_string: str = (
        "mongodb://admin:password@localhost:27017/bydgoszcz?authSource=admin"
    )

settings = Settings()
