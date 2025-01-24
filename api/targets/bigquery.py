from typing import List

from google.cloud import bigquery


class BigQuery:
    def __init__(self, config: dict):
        self.config = config
        self.client = bigquery.Client()

    def parquet_to_bigquery(self, dataset_name: str, table_name: str):

        try:
            job_config = bigquery.LoadJobConfig(
                source_format=bigquery.SourceFormat.PARQUET,
                write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
            )

            load_job = self.client.load_table_from_uri(
                source_uris=f"gs://{self.config["service"]["cloud_storage"]["bucket_name"]}/{table_name}.parquet",
                destination=f"{self.config['project_id']}.{dataset_name}.{table_name}",
                job_config=job_config,
            )

            load_job.result()

            print(f"Table {table_name} saved on BigQuery!")
        except Exception as e:
            print(e)
            pass
