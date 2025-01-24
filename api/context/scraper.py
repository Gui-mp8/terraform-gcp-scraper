from typing import Any, Dict, List

from api.interfaces.investing_strategy_interface import InvestingSI


class Scraper:
    def __init__(self, scraper_strategy: InvestingSI) -> None:
        self._scraper = scraper_strategy

    def data(self, contract: str) -> List[Dict[str, Any]]:
        return self._scraper.get_data(contract)
