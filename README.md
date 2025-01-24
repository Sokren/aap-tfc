# AAP-TFC

This repository contains a demo showcasing the integration between Terraform Cloud and Ansible Automation Platform.

## Prerequisites

Before getting started, make sure you have installed or configured:

- [Terraform Cloud](https://www.hashicorp.com/products/terraform/cloud)
- [Packer](https://www.packer.io/downloads)
- [HCP Packer](https://www.hashicorp.com/products/packer) *(Optional, you need to adapt the code)*
- [Ansible Automation Platform](https://www.redhat.com/en/technologies/management/ansible)
- An [AWS](https://aws.amazon.com/) account with appropriate permissions

## Repository Structure

Here is a brief description of the main folders and files in the repository:

- **aap/**: Contains Terraform code to manage Ansible Automation Platform.
- **aws-ec2/**: Configurations for managing EC2 instances on AWS.
- **aws-infra/**: Scripts and configurations for deploying basic AWS infrastructure (networking, security, etc.).
- **packer-images/**: Packer templates for creating a custom AMI image.
- **tfc-config/**: Specific configurations for Terraform Cloud.
- **website/**: Source code for the websites.

## Variable Sets

You need to configure three Variable Sets:

1. **hcp-creds**

| Variable Name          | Value                                 | Category              | Sensitive |
|------------------------|---------------------------------------|-----------------------|-----------|
| `HCP_CLIENT_ID`        | Your HCP Client ID                   | Environment Variable  | No        |
| `HCP_CLIENT_SECRET`    | Your HCP Secret                      | Environment Variable  | Yes       |

2. **Aws-creds**

| Variable Name          | Value                                 | Category              | Sensitive |
|------------------------|---------------------------------------|-----------------------|-----------|
| `AWS_ACCESS_KEY_ID`    | Your AWS Access Key ID               | Environment Variable  | No        |
| `AWS_SECRET_ACCESS_KEY`| Your AWS Secret Access Key           | Environment Variable  | Yes       |

3. **RH-AAP**

| Variable Name          | Value                                 | Category              | Sensitive |
|------------------------|---------------------------------------|-----------------------|-----------|
| `aap_host_url`         | The URL of your AAP                  | Terraform Variable    | No        |
| `aap_username`         | TFC Username for AAP                 | Terraform Variable    | No        |
| `aap_password`         | TFC Password for AAP                 | Terraform Variable    | Yes       |

## Demonstration Steps

1. Fork the GitHub repository.
2. Create a new project: `Demo-AAP-TFC`.
3. Create a new workspace within the newly created project.
4. Select `Version Control Workflow` as the VCS provider and link the forked repository.
5. Open the `Advanced options` settings and set **Terraform Working Directory** to `/tfc-config/`.
6. Enter the following variables:

| Variable Name          | Value                                 |
|------------------------|---------------------------------------|
| `tfc_org`              | *Your Terraform Cloud organization*     |
| `tfc_token`            | *Your Terraform Cloud token*            |
| `vcs_provider_name`    | GitHub App                            |
| `github_username`      | *Your GitHub username*                  |
| `aws_resources_tag`    | demo-aap-test                         |
| `pub_ssh_key`          | *Your public SSH key (for direct SSH access)* |
| `priv_ssh_key`         | *Your private SSH key (for direct SSH access)* |
| `aws_region`           | us-east-1                             |
| `myip`                 | *Your public IP address*                |
| `hcp_packer_url`       | *Your HCP Packer URL (optional, adapt the code if needed)* |
| `hcp_packer_hmac`      | *Your HCP Packer HMAC (optional, adapt the code if needed)* |
| `worker_name`          | demo-aap                              |
| `worker_tag`           | upstream                              |

7. Plan and apply the Terraform code on Terraform Cloud:
   - It will create a new project **AAP-TFC** and three workspaces.
   - It will automatically plan **AAP-TFC-aws-infra**.
8. Approve the apply for **AAP-TFC-aws-infra**.
9. Once **AAP-TFC-aws-infra** completes, it will automatically trigger a plan for **AAP-TFC-aws-ec2**. Apply this plan.
10. After **AAP-TFC-aws-ec2** completes, you may encounter a `Warning: Error making request`. This is expected; Continuous Validation checks port `8080`, which will be configured by **Ansible Automation Platform**.
11. Finally, apply **AAP-TFC-aap** to complete the setup.

## Cleanup

To delete the demonstration setup, destroy the workspaces in this order:
1. **AAP-TFC-aap**
2. **AAP-TFC-aws-ec2**
3. **AAP-TFC-aws-infra**
4. **tfc-config**
5. You can now delete **tfc-config** and the project **Demo-AAP-TFC**