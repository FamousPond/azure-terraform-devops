This repository is for training myself on how to use Azure DevtOps (ADO) pipelines to use Terraform to deploy infrastructure to Azure.  

### manual_test_1
This test was just to see how Terraform works and how to structure the configuration fies. I manually deployed it using the cli. 

### manual_test_2
This test went a bit deeper. I used an Azure storage account to remotely store the Terraform config file, and I deployed two machines one of which had a public IP. 

### automated_test_1
This test is now using Azure DevOps pipelines to deploy to Azure. Two ADO pipelines are being created. The first (`pipelines/terraform.yml`) runs on a GitHub PR and merge into `main`, and does the following in different stages:
1. Checks the Terraform format and validates it. 
2. Runs Terraform plan and outputs the plan file as a pipeline artifact. 
3. When merging into main it applies the Terraform config.

If there is an error in the first step, the PR is blocked from being merged into main. 

The second (`pipelines/terraform-destroy.yml`) runs manually and destroys the Azure deployment. 

`automated_test_1/env_1` is a very simple environment to test the initial setup. `automated_test_1/env_2` will be a more complex environment. More on this to come.
