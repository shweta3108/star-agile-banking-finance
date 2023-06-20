#!/usr/bin/env python3

import subprocess

# Run Terraform output command to get the IP addresses
output = subprocess.check_output(["terraform", "output"]).decode("utf-8")
output_lines = output.splitlines()

# Extract the IP addresses from the output
test_server_ip = output_lines[0].split(" = ")[1].strip('"')
production_server_ip = output_lines[1].split(" = ")[1].strip('"')

# Generate the inventory file
with open("servers_inventory", "w") as f:
    f.write("[testservers]\n")
    f.write(test_server_ip + "\n\n")
    f.write("[prodservers]\n")
    f.write(production_server_ip + "\n\n")
    f.write("[webservers:vars]\n")
    f.write('ansible_ssh_user="ubuntu"')

# Print the inventory file content
with open("servers_inventory", "r") as f:
    print(f.read())
