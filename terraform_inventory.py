#!/usr/bin/env python3

import subprocess
import json

# Run Terraform output command to get the IP addresses
output = subprocess.check_output(["terraform", "output", "-json"]).decode("utf-8")
output_json = json.loads(output)

# Extract the IP address of the production server from the output
production_server_ip = output_json.get("production_server_ip", {}).get("value")

# Generate the inventory file if the IP address is available
if production_server_ip:
    with open("servers_inventory", "w") as f:
        f.write("[prodservers]\n")
        f.write(production_server_ip + "\n\n")
        f.write("[webservers:vars]\n")
        f.write("ansible_ssh_user=ubuntu")

    # Print the inventory file content
    with open("servers_inventory", "r") as f:
        print(f.read())
else:
    print("Failed to extract the production server IP address from the Terraform output.")
