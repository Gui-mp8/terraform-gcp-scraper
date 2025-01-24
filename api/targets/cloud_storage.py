import json
from typing import Any, Dict, List

import pandas as pd
from google.cloud import storage


class CloudStorage:
    def __init__(self, config: dict) -> None:
        self.config = config
        self.storage = storage.Client(project=self.config["project_id"])
        self.bucket = self.storage.bucket(
            self.config["service"]["cloud_storage"]["bucket_name"]
        )

    def upload_json(
        self, data: List[Dict[str, Any]], destination_blob_name: str
    ) -> None:

        if data:

            df = pd.DataFrame(data)

            uri = f"gs://{self.config["service"]["cloud_storage"]["bucket_name"]}/{destination_blob_name}.parquet"
            df.to_parquet(uri, index=False)

            print(f"Table {destination_blob_name} saved on Storage!")

        else:
            print(f"None data for {destination_blob_name}")

        # json_data = json.dumps(data, indent=4)

        # blob = self.bucket.blob(destination_blob_name)
        # blob.upload_from_string(json_data, content_type='application/json')

        # print(f"Data successfully uploaded !")
