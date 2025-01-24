from pydantic import BaseModel


class BloombergSchema(BaseModel):
    date: str | None = None
    close: str | None = None
    open: str | None = None
    high: str | None = None
    low: str | None = None
    volume: int | None = None
