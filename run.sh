#!/bin/bash
sudo rm -rf .terraform/ terraform.tfstate terraform.tfstate.backup .terraform.lock.hcl
/usr/local/bin/terraform init

/usr/local/bin/terraform apply --auto-approve