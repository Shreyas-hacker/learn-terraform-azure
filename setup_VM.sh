# !/bin/bash

terraform init --upgrade
terraform apply -auto-approve
# ssh user@machine python < script.py - arg1 arg2
terraform destroy -auto-approve