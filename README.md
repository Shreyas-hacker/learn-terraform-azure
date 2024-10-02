# Terraform Azure Setup

This repository contains Terraform configurations and scripts to set up and manage Azure resources, along with a testing environment using Docker and Python.

## Repository Structure
. ├── .gitignore ├── .ssh/ ├── .terraform/ │ ├── providers/ │ │ └── registry.terraform.io/ │ │ └── hashicorp/ │ │ ├── azurerm/ │ │ ├── local/ │ │ ├── null/ │ │ └── tls/ ├── .terraform.lock.hcl ├── external.sh ├── main.tf ├── outputs.tf ├── providers.tf ├── README.md ├── setup.sh ├── terraform.tfstate ├── terraform.tfstate.backup ├── testing/ │ ├── Dockerfile │ ├── requirements.txt │ └── storage_script.py ├── variables.tf

### Prerequisites
 - [Terraform](https://www.terraform.io/downloads.html)
 - [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)