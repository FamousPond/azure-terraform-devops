This repository is for training myself on how to use Azure GitOps pipelines to use Terraform to deploy infrastructure to Azure.  

### manual_test_1
This test was just to see how Terraform works and how to structure the configuration fies. I manually deployed it using the cli. 

### manual_test_2
This test went a bit deeper. I used an Azure storage account to remotely store the Terraform config file, and I deployed two machines one of which had a public IP. 

### automated_test_1
This test is now using Azure DevOps pipelines to deploy to Azure. `automated_test_1/env_1` is a very simple environment to test the initial setup. `automated_test_1/env_2` will be a more complex environment. More on this to come.
