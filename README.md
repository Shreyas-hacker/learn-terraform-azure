# Terraform Azure Setup

This repository contains Terraform configurations and scripts to set up and manage Azure resources, along with a testing environment using Docker and Python.

## Repository Structure

## Prerequisites
 - [Terraform](https://www.terraform.io/downloads.html)
 - [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

## Automating VM Setup

To streamline the process of setting up your Azure VM, we've provided an external script that automates the entire setup process. This script handles everything from resource provisioning to software installation and configuration.

### Running the Automation Script

1. Ensure you have met all the prerequisites listed above.
2. Navigate to the root directory of this project.
3. Run the following command: `./setup_vm.sh`

This script will:
- Initialize Terraform
- Apply the Terraform configuration to create Azure resources
- Install necessary software and dependencies
- Connect to the newly created VM
- Configure the VM for your specific use case

4. Follow any prompts that appear during the script execution.

After the script completes, your Azure VM will be fully set up and also torn down after the execution of the entire `.sh` script.

Note: Make sure to review the `setup_vm.sh` script before running it to understand the exact steps it will perform in your Azure environment.