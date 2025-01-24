from abc import ABC, abstractmethod
from typing import Any, Dict, List


class InvestingSI(ABC):
    def __init__(self):
        self._url = None

    @property
    def url(self) -> str:
        return self._url

    @url.setter
    def url(self, endpoint: str) -> None:
        self._url = endpoint

    @abstractmethod
    def get_data(self, contract: str) -> List[Dict[str, Any]]:
        pass
