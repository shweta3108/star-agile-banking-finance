#!/usr/bin/env python3

import subprocess
import json

# Run Terraform output command to get the IP addresses
output = subprocess.check_output(["terraform", "output", "-json"]).decode("utf-8")
inventory = json.loads(output)

# Define the inventory structure
inventory_data = {
    "test_servers": {
        "hosts": [inventory["test_server_ip"]]
    },
    "production_servers": {
        "hosts": [inventory["production_server_ip"]]
    }
}

# Save the inventory data to the inventory file
with open("servers_inventory", "w") as f:
    json.dump(inventory_data, f)

# Print the inventory data as JSON
print(json.dumps(inventory_data))
