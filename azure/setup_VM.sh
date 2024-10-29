# !/bin/bash

terraform init --upgrade
terraform apply -auto-approve

#Extract specific outputs
public_ip=$(terraform output -raw public_ip_address)
resource_group=$(terraform output -raw resource_group_name)

#Print output for sanity check
echo "Public IP: $public_ip"
echo "Resource Group: $resource_group"

# #Use public IP to ssh into VM and run python script
ssh -o StrictHostKeyChecking=accept-new -i ./.ssh/id_rsa.pem azureadmin@$public_ip "cd tmp/testing && pip3 install -r requirements.txt && python3 storage_script.py"

terraform destroy -auto-approve