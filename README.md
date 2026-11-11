# Azure Terraform Deployment Pipeline Training

A personal project for learning to deploy Azure infrastructure with Terraform through Azure DevOps (ADO) YAML pipelines. I built this to transfer my experience with AWS, Pulumi and GitHub Actions to Azure, Terraform and Azure DevOps. The development log below shows how it progressed.

## Current deployment
![ADO deployment diagram](docs/deployment_diagram.png) 
*The diagram shows the environment before load balancing was added.*

| Tier | Resources | Access |
|---|---|---|
| Web | Two Ubuntu VMs behind a public Azure Load Balancer, with no public IPs of their own | HTTP (8080) from the internet through the load balancer, with an HTTP health probe; SSH only from Azure Bastion |
| Backend | Ubuntu VM in a private subnet, outbound via a NAT gateway | Only from the web tier's application security group; SSH only from Azure Bastion |
| Secrets | Key Vault behind a private endpoint, with public access disabled | Only the backend VM's managed identity, via RBAC (Key Vault Secrets User) |
 
Supporting resources: a VNet with four subnets, network security groups and application security groups, Azure Bastion, and a private DNS zone for the Key Vault endpoint.
 
## Pipelines
 
All pipelines share variables from `pipelines/variables.yml` and use the `pipelines/templates/setup.yml` template, which checks out the repo, installs Terraform and runs `terraform init`. Each step can be toggled with parameters.
 
### Deploy (`pipelines/terraform.yml`)
 
Runs on pull requests to `main` and on merges into `main`:
 
1. **Validate:** checks Terraform formatting (`terraform fmt -check`) and validates the configuration.
2. **Plan:** creates a Terraform plan and publishes it as a pipeline artifact.
3. **Apply:** on merge to `main` only, applies the saved plan through an ADO deployment environment.
If validation or planning fails, the pull request is blocked from merging.
 
### Destroy (`pipelines/terraform-destroy.yml`)
 
Run manually. It requires typing `DESTROY` to confirm, then plans and applies a destroy of the deployment.
 
### Monitor (`pipelines/terraform-monitor.yml`)
 
Runs on a daily schedule and checks the Terraform state. If any resources are still running, the pipeline fails, and ADO notifications email me so I don't leave resources up (and paying for them) by accident.

## Development log

Most recent first.

### automated_test_4
This test  firstly added a Load Balancer in front of two web VMs, with an HTTP health probe and a load-balancing rule for port 8080. Next, I will refactor the configuration into Terraform modules.

### automated_test_3
This test is going to add another pipeline to monitor if I have left systems up overnight. It will run daily at 2 am and if I have left any systems up overnight it will alert me. This is to ensure I don't leave resources up when I am not using them.  

The pipeline fails if there are resources up, and I have notifications setup in ADO to email me if this pipline fails. 

There wil be no folder for this as it is going to be put into the pipelines folder. 


### automated_test_2
This test will use the two pipelines from the last test, but I am going to upgrade the deployment. Instead of just a single VNet, it will be a mock web service environment with bastion, key vault, NSGs, private endpoint and two Ubuntu machines. See the full plan here: 

I have also split up the main Terraform file into multiple Terraform files for modularity. 


### automated_test_1
This test is now using Azure DevOps pipelines to deploy to Azure. Two ADO pipelines are being created. The first (`pipelines/terraform.yml`) runs on a GitHub PR and merge into `main`, and does the following in different stages:
1. Checks the Terraform format and validates it. 
2. Runs Terraform plan and outputs the plan file as a pipeline artifact. 
3. When merging into main it applies the Terraform config.

If there is an error in the first step, the PR is blocked from being merged into main. 

The second (`pipelines/terraform-destroy.yml`) runs manually and destroys the Azure deployment. 

Both these pipelines get shared variables from the `pipelines/variables.yml` file, and use the `pipelines/templates/setup.yml` template. This template checks out the repo, installs terraform and runs terraform init. Each of these are toggleable through parameters. 

`automated_test_1/` contains a very simple environment to test the pipelines with. 

### manual_test_2
This test went a bit deeper. I used an Azure storage account to remotely store the Terraform config file, and I deployed two machines one of which had a public IP.

### manual_test_1
This test was just to see how Terraform works and how to structure the configuration fies. I manually deployed it using the cli. 
