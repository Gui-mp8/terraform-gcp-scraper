from datetime import datetime
from typing import Any

from pydantic import BaseModel, field_validator


class ChinaIndexSchema(BaseModel):
    date: str | None = None
    actual_state: str | None = None
    close: str | None = None
    forecast: str | None = None

    @field_validator("date", mode="before")
    @classmethod
    def int_to_string_date_timestamp(cls, value: Any) -> str:

        if isinstance(value, int):
            date = datetime.fromtimestamp(value / 1000)
            return date.isoformat()

        return value
