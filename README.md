# Economic data Extraction

This project uses Terraform with GCP to scraps data from [Chinese Index](https://br.investing.com/economic-calendar/chinese-caixin-services-pmi-596), [Bloomberg Commodity Index](https://br.investing.com/indices/bloomberg-commodity) and [USD/CNY Index](https://br.investing.com/currencies/usd-cny) make available these 3 tables at **BigQuery** for analysis.

## Architecture
![Image](https://github.com/user-attachments/assets/de18dd4c-f2ea-4051-9f5f-e17234982cdd)

## Pipeline Details

**Data Extraction**:

- The DAG triggers a Cloud Run API that uses Selenium and Requests to scrape the required data.

**Data Storage**:

- Extracted data is saved in Cloud Storage in Parquet format.

**Data Analysis**:

- The DAG writes the Parquet data to BigQuery, making it available for analysis.

## Pre-Requisites

Before running the code, ensure you have the following tools installed:

- [Docker](https://docs.docker.com/engine/install/ubuntu/)

- [Google Cloud Account](https://cloud.google.com/free?hl=en)

- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

## Configuration

After creating the Google Cloud Account you will need pass trough some steps

- Step 1 : [Create a service account key](https://youtu.be/dj9fxiuz4WM?t=66)

- Step 2 : Navigate to the terraform directory. Create a credentials folder inside it (if it doesn’t already exist). Save the service account key file in this directory with the name `suzano-challenge.json`, or update the configuration to match your filename.

- Step 3 : Modify the file `config.yaml` file in the root directory with your project-specific details.

- Step 4 : Install `make` to run the provided Makefile commands:

    ```
    sudo apt -y install make
    ```

## Execution

Step 1 -  Clone the repository:
```
git clone git@github.com:Gui-mp8/economic_data_extraction.git
```

Step 2 -  Run terraform (Run each line separately):
```
make infra
make infra_plan
make infra_apply
```

> **OBS:** Wait about 5 minutes to airflow become available

Step 3 - To trigger the Cloud Build, you need to make any commit and then Pull Request in the api/ directory.
This step is essential because the Cloud Run's continuous deployment (CD) pipeline is configured through Cloud Build.

Step 4 - Enter at airflow in the IP Address that'll appear at your CMD like "`35.192.180.114`",
and put at the url like this, `http://35.192.180.114:8081`, and then do the login using admin admin

Step 5 - It's necessary to get the Cloud Run Aplication URL,
and create a [HTTP connection at Airflow](https://airflow.apache.org/docs/apache-airflow/stable/howto/connection.html)

Step 6 - Run the suzano_challenge dag

## Improvements
- Make the DAG more modular by better separating each function in the code.

- Create a trigger at Cloud Build with terraform, to automatically update Airflow on the VM, after each commit in the dags/ and include/ folders.

- Develop tests to ensure reliability.

- Create a Docker container to run on Compute Engine, avoiding potential issues with updates via apt update.

- Save the raw data directly to the storage and authenticate pydantic to save it to the bq (we're authenticating pydantic directly because we think we know that the API won't be changed in the future).

> **Aviso:** Clone o Repositorio e o transform e o salve em outro repositorio publico, no momento não consegui autentificar o github privado pelo terraform.