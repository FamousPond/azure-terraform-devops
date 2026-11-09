This file contains what I have learn about terraform. It's commands, how to use it and it's similarities to Pulumi.

## Commands
`terraform init` - Initialises Terraform and installs the required providers (that you defined).

`terraform fmt` - Formats the Terraform files for you to ensure consistent formatting. 

`terraform validate` - Validates your Terraform configuration. 

`terraform plan -out tfout` - plans the Terraform configuration and shows what will be made like Pulumi preview. the `-out tfout` gives the plan a name and saves it locally. 

`terraform apply "tfplan"` - Applies the plan. Like Pulumi up. creates a file `terraform.tfstate` that is like the Pulumi stack file. 

`terraform show` - Shows the running Terraform.

`terraform state list` - Lists all the Terraform resources running.

`terraform destroy` - Destroys the Terraform resources running. 

`terraform providers lock -platform=linux_amd64 -platform=darwin_arm64 -platform=windows_amd64` - creates the terraform lock file that works on everything

## How to write it

Start with this part:
```terraform
terraform {
  # What is this version for?
  required_version = ">= 1.9"

  # required_providers are like the libraries terraform will use from the terraform registry (by default), or elsewhere?
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" } # This is telling terraform I want to use azure
    random  = { source = "hashicorp/random", version = "~> 3.6" }  # this is telling terraform I want to use this random library
  }
}
```

Then add provider specifications:
```terraform
# provider configures the specific provider.
provider "azurerm" {
  features {}
}
```

You can then define resources like this and reference them:

```terraform
# This is an azure resource group.
resource "azurerm_resource_group" "example_rg" {
  name     = "rg-dev"
  location = "australiasoutheast"
}

# This is a storage account which is just a space to store things like s3 but gives more optionality. (s3 only stores blobs)
resource "azurerm_storage_account" "storage" {
  name                     = "sttflearn${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.example_rg.name
  location                 = azurerm_resource_group.example_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```
