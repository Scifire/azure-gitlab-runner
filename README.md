# azure-gitlab-runner
This repo contains example config for the [Gitlab Autoscaler](https://docs.gitlab.com/runner/executors/docker_autoscaler.html) base on Azure VM Scale Sets.   
All Azure resources are created with terraform and the image is created with packer.  

### This is just an example, not designed for production use or to be free of mistakes! You have to adjust the example to your own needs, like passwords, Azure IDs, SSH keys etc.

Manual steps are listed below.   

## Used tools
- terraform
- packer

## Required Azure Resources
- Azure VM (always running)
- Custom Azure VM Image
- Azure VM Scale Set
- Azure compute Gallery
- VM image version
- User Managed Identity


## How to setup:
1. Go into terraform folder and do `terraform init`
2. Then do `terraform apply -target=azurerm_resource_group.prod-gitlab`
2. Go into packer folder and `packer build gitlab-runner.json`
3. Go back into terraform folder then do `terraform plan` and `terraform apply`
6. Install fleeting plugin on static runner (vm-prod-gitlab-runner)
    - `wget https://gitlab.com/gitlab-org/fleeting/plugins/azure/-/releases/v0.3.0/downloads/fleeting-plugin-azure-linux-amd64`
    - `mv fleeting-plugin-azure-linux-amd64 fleeting-plugin-azure`
    - `mv fleeting-plugin-azure /usr/bin/`
    - `chmod +x /usr/bin/fleeting-plugin-azure`
7. Add runner config [Gitlab Runner config](gitlab-runner-config.toml) to `/etc/gitlab-runner/config.toml` of the static runner

#### Resources for information
https://docs.gitlab.com/runner/executors/docker_autoscaler.html#example-azure-scale-set-for-1-job-per-instance   
https://gitlab.com/gitlab-org/gitlab-runner/-/issues/29223   
https://gitlab.com/gitlab-org/fleeting/plugins/azure/-/tree/main?ref_type=heads    


https://docs.gitlab.com/ee/ci/pipelines/cicd_minutes.html#gitlab-hosted-runner-costs   
https://azure.microsoft.com/de-de/pricing/details/virtual-machines/linux/#pricing   