from typing import Any, Dict

import yaml


def load_config() -> Dict[str, Any]:
    with open("./config.yaml", "r") as file:
        config_data = yaml.safe_load(file)
    return config_data
