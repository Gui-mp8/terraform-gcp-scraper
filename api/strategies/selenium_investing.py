import json
from typing import Any, Dict, List

from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager

from api.contracts.bloomberg_schema import BloombergSchema
from api.contracts.usd_cny_schema import UsdCnySchema
from api.interfaces.investing_strategy_interface import InvestingSI


class SeleniumInvestingStrategy(InvestingSI):

    def _setup_driver(self) -> webdriver.Chrome:
        # Configurar opções para o Chrome
        chrome_options = Options()
        chrome_options.add_argument("--headless=new")  # Novo modo headless
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")
        chrome_options.add_argument("--disable-gpu")
        chrome_options.add_argument("--window-size=1920,1080")
        chrome_options.add_argument("--remote-debugging-port=9222")
        chrome_options.add_argument(
            "--user-agent=Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
            # "--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        )

        # Inicializar o WebDriver
        driver = webdriver.Chrome(
            service=Service(
                ChromeDriverManager(driver_version="132.0.6834.83").install()
            ),  # driver_version="132.0.6834.83"
            options=chrome_options,
        )
        return driver

    def get_data(self, contract: str) -> List[Dict[str, Any]]:

        script = f"""
        return fetch('{self.url}', {{
            method: "GET",
            headers: {{
                "accept": "*/*",
                "accept-encoding": "gzip, deflate, br, zstd",
                "accept-language": "pt-BR,pt;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6",
                "content-type": "application/json",
                "domain-id": "www",
                "origin": "https://www.investing.com",
                "referer": "https://www.investing.com/",
                "sec-fetch-dest": "empty",
                "sec-fetch-mode": "cors",
                "sec-fetch-site": "same-site",
                "user-agent": "Mozilla/5.0"
            }}
        }})
        .then(response => response.json())
        .then(data => JSON.stringify(data))
        .catch((error) => JSON.stringify({{"error": error.message}}));
        """
        try:
            driver = self._setup_driver()
            json_data = json.loads(driver.execute_script(script))
        finally:
            driver.quit()

        validated_data = []

        if "data" in json_data:
            for item in json_data["data"]:
                if contract == "bloomberg":
                    contract_data = BloombergSchema(
                        date=item.get("rowDateTimestamp", ""),
                        close=item.get("last_close", ""),
                        open=item.get("last_open", ""),
                        high=item.get("last_max", ""),
                        low=item.get("last_min", ""),
                        volume=item.get("volumeRaw", ""),
                    )

                if contract == "usd_cny":
                    contract_data = UsdCnySchema(
                        date=item.get("rowDateTimestamp", ""),
                        close=item.get("last_close", ""),
                        open=item.get("last_open", ""),
                        high=item.get("last_max", ""),
                        low=item.get("last_min", ""),
                        volume=item.get("volumeRaw", ""),
                    )

                validated_data.append(contract_data.model_dump())

            return validated_data
        else:
            print("Expected key 'data' not found in the response.")

