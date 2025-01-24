from typing import Any, Dict, List

import requests

from api.contracts.china_index_schema import ChinaIndexSchema
from api.interfaces.investing_strategy_interface import InvestingSI


class RequestsInvestingStrategy(InvestingSI):

    def get_data(self, contract: str) -> List[Dict[str, Any]]:
        response = requests.get(self.url)
        if response.status_code == 200:
            data = response.json()

            validated_data = []

            if "attr" in data:
                for item in data["attr"]:

                    if contract == "china_index":
                        contract_data = ChinaIndexSchema(
                            date=item.get("timestamp", ""),
                            actual_state=item.get("actual_state", ""),
                            close=item.get("actual_formatted", ""),
                            forecast=item.get("forecast_formatted", ""),
                        )

                    validated_data.append(contract_data.model_dump())

                return validated_data
        else:
            print("Expected key 'data' not found in the response.")
