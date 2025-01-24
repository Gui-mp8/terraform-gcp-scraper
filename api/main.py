from datetime import datetime

from fastapi import APIRouter, Depends, FastAPI

from api.context.scraper import Scraper
from api.strategies.requests_investing import RequestsInvestingStrategy
from api.strategies.selenium_investing import SeleniumInvestingStrategy
from api.targets.bigquery import BigQuery
from api.targets.cloud_storage import CloudStorage
from api.utils.config import load_config


scraper = APIRouter()


@scraper.get("/")
def root():
    config = load_config()

    today = datetime.now().strftime("%Y-%m-%d")

    selenium = SeleniumInvestingStrategy()

    selenium.url = f"https://api.investing.com/api/financialdata/historical/948434?start-date=1991-01-01&end-date={today}&time-frame=Monthly&add-missing-rows=false"
    bloomberg = Scraper(scraper_strategy=selenium)
    bloomberg_data = bloomberg.data(contract="bloomberg")
    CloudStorage(config).upload_json(bloomberg_data, "bloomberg")
    BigQuery(config).parquet_to_bigquery(
        dataset_name="economic_data", table_name="bloomberg"
    )

    selenium.url = f"https://api.investing.com/api/financialdata/historical/2111?start-date=1991-01-01&end-date={today}&time-frame=Monthly&add-missing-rows=false"
    usc_cny = Scraper(scraper_strategy=selenium)
    usc_cny_data = usc_cny.data(contract="usd_cny")
    CloudStorage(config).upload_json(usc_cny_data, "usc_cny")
    BigQuery(config).parquet_to_bigquery(
        dataset_name="economic_data", table_name="usc_cny"
    )

    requests = RequestsInvestingStrategy()

    requests.url = "https://sbcharts.investing.com/events_charts/eu/596.json"
    china_index = Scraper(scraper_strategy=requests)
    china_index_data = china_index.data(contract="china_index")
    CloudStorage(config).upload_json(china_index_data, "china_index")
    BigQuery(config).parquet_to_bigquery(
        dataset_name="economic_data", table_name="china_index"
    )

    return {"text": "Data saved at Storage"}


app = FastAPI()

app.include_router(scraper, prefix="/scraper")

