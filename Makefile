## Docker
docker_build_run:
	docker build -f api.Dockerfile -t suzano-challenge-448218 .
	docker run -p 8000:8000 suzano-challenge-448218

# docker_run:
# 	docker run -p 8000:8000 suzano-challenge-448218

### Terraform
infra:
	terraform -chdir=./terraform init

infra_plan:
	terraform -chdir=./terraform plan

infra_apply:
	terraform -chdir=./terraform apply -auto-approve

infra_destroy:
	terraform -chdir=./terraform destroy -auto-approve

infra_compute_engine:
	terraform -chdir=./terraform apply -target module.compute_engine

### Astronomer
astro_start:
	sudo astro config set webserver.port 8081
	sudo astro dev start

astro_stop:
	sudo astro dev stop


# CI
sort-imports:
	isort ./api

format:
	black ./api

lint:
	ruff check ./api --ignore F401

test:
	pytest -v tests/

CI:
	make sort-imports
	make format
	make lint
