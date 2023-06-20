#!/usr/bin/env python3

import subprocess
import json
import yaml

# Run Terraform output command to get the IP addresses
output = subprocess.check_output(["terraform", "output", "-json"]).decode("utf-8")
inventory = json.loads(output)

# Define the inventory structure
inventory_data = {
    "test_servers": {
        "hosts": [inventory["test_server_ip"]["value"]]
    },
    "production_servers": {
        "hosts": [inventory["production_server_ip"]["value"]]
    }
}

# Save the inventory data to the inventory file in YAML format
with open("servers_inventory", "w") as f:
    yaml.dump(inventory_data, f)

# Print the inventory data as YAML
print(yaml.dump(inventory_data))
