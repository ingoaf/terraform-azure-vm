# terraform-azure-vm

Terraform code to spin up a small Ubuntu VM in the Azure Cloud. To prevent unexpected behaviour execute all commands in a Powershell.

## Prerequisites

- Terraform
- Azure Subscription
- Azure CLI
- (not required but recommended): VS Code with Remote-SSH extension.

## Getting Started

- Replace the ip in `terraform.tfvars` with your own ip address. Pay attention to keep the cidr block format.
- Set the paths to the public and private key file in `terraform.tfvars` to establish an SSH connection to your VM. 
- Replace the path in `windows-ssh-script.tpl` with a path to your own ssh config.
- Modify the `customdata.tpl` file to prepare the VM in your own way.
- Run `az login` and login to your Azure Account.
- Run `terraform init` to initialize terraform working directory.
- Execute `terraform apply` and confirm
- (Optional) Connect to your Azure VM via Remote-SSH extension (Connect to Host...)
