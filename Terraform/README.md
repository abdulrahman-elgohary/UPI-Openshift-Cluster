## Table of Content
- **[Terraform Structure](#terraform-structure)**

- **[Prequesites](#prequesites)**
  
  - [Step 1: Install Terraform](#step-1-install-terraform)
  - [Step 2: Install AWS CLI](#step-2-install-aws-cli)
  - [Step 3: Configure AWS CLI](#step-3-configure-aws-cli)

- **[Steps:](#steps)**

  - [Step 1: Prepare the Backend of Terraform](#step-1-prepare-the-backend-of-terraform)
  - [Step 2: Start creating the modules](#step-2-start-creating-the-modules)
  - [Step 3: Create the `vpc` module](#step-3-create-the-vpc-module)
  - [Step 4: Create the `subnet` module](#step-4-create-the-subnet-module)
  - [Step 5: Create the `security_group` module](#step-5-create-the-security_group-module)
  - [Step 6: Create the `ec2` module](#step-6-create-the-ec2-module)
  - [Step 7: Create the `iam_role` module](#step-7-create-the-iam_role-module)
  - [Step 8: Apply Terraform resources](#step-8-apply-terraform-resources)

## Terraform Structure

![image](https://github.com/user-attachments/assets/564f9cd6-6937-4a72-b8fb-16490ab1b81e)

## Prequesites 
### Step 1: Install Terraform 

- Update Ubuntu System
  ```bash
  sudo apt update -y
  ```
- Install required dependencies for downloading Terraform
  ```bash
  sudo apt install -y gnupg software-properties-common curl
  ```
- Add the Hashicorp GPG Key
  ```bash
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  ```
- Add the HashiCorp Repository
  ```bash
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  ```
- Update the system again after adding the repo
  ```bash
  sudo apt update -y 
  ```
- Install Terraform 
  ```bash
  sudo apt install terraform
  ```
- Enable Tab Completion
  ```bash
  terraform -install-autocomplete
  ```
- Restart your terminal session to apply this change.
---

### Step 2: Install AWS CLI
- Download the AWS CLI v2 Package
  ```bash
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  ```
- Unzip the Downloaded File
  ```bash
  unzip awscliv2.zip
  ```
- Run the Installer
  ```bash
  sudo ./aws/install
  ```
### Step 3: Configure AWS CLI
- Go to your AWS acoount `IAM` > `User` > Press on your IAM User > Choose `Security Credentials` tab > Navigate to `Create access key`
- After Creating your access key execute the following command
  ```bash
  aws configure
  ```
- Insert the following entries
  ```bash
  AWS Access Key ID [None]: <your-access-key-id>
  AWS Secret Access Key [None]: <your-secret-access-key>
  Default region name [None]: us-east-1
  Default output format [None]: json
  ```
---

## Steps:

## Step 1: Prepare the Backend of Terraform

**1.1 Adjust the cloud provider**
- Create a directory and name it `Terraform` then navigate to it.
  ```bash
  mkdir Terraform && cd Terraform
  ```
- Create a file called `provider.tf` and write the following entry: **[Entry of proivider.tf](./provider.tf)**

**1.2 Apply the Lock user feature**
- This feature will prevent two or more users to manage terraform at the same time.

- Navigate to `S3` Service in your aws account and create S3 bucket manually and give it a unique name

  ![image](https://github.com/user-attachments/assets/84907056-65ac-492b-a604-d5fbedc382cd)

- Navigate to `DynamoDB` Service > `Tables` > `Create table`
- Give it a name then make the primary key `LockID`

  ![image](https://github.com/user-attachments/assets/816089cf-266e-4d58-8a28-ab6844265128)

- Create `backend.tf` file with the following entry: **[Entry of backend.tf](./backend.tf)**

---
## Step 2: Start creating the modules
- Create the `main.tf` root file
  ```bash
  touch main.tf
  ```
- Create 4 modules with their required files `main.tf` , `variables.tf` , `terraform.tfvars` `outputs.rf`.
  ```bash
  mkdir -p modules/{vpc,subnet,ec2,security_group}
  tocuh modules/{vpc,subnet,ec2,security_group}/{main.tf,variables.tf,terraform.tfvars,outputs.tf}
  ```
---
## Step 3: Create the `vpc` module.
- Define the following variables in `variables.tf`: **[Entry of `VPC` variables.tf](./modules/vpc/variables.tf)**

- Define the required outputs to be used in other modules in `outputs.tf` file: **[Entry of `VPC` outputs.tf](./modules/vpc/outputs.tf)**

- Define the resources inside `main.tf` file: **[Entry of `VPC` main.tf](./modules/vpc/main.tf)**

---
## Step 4: Create the `subnet` module.

- Define the following variables in `variables.tf`: **[Entry of `subnet` variables.tf](./modules/subnet/variables.tf)**

- Define the required outputs to be used in other modules in `outputs.tf` file: **[Entry of `subnet` outputs.tf](./modules/subnet/outputs.tf)**
  
- Define the resources inside `main.tf` file: **[Entry of `subnet` main.tf](./modules/subnet/main.tf)**
---
## Step 5: Create the `security_group` module.

- Define the following variables in `variables.tf`: **[Entry of `security_group` variables.tf](./modules/security_group/variables.tf)**

- Define the required outputs to be used in other modules in `outputs.tf` file: **[Entry of `security_group` outputs.tf](./modules/security_group/outputs.tf)**
 
- Define the resources inside `main.tf` file: **[Entry of `security_group` main.tf](./modules/security_group/main.tf)**
---
## Step 6: Create the `ec2` module.

- Define the following variables in `variables.tf`: **[Entry of `ec2` variables.tf](./modules/ec2/variables.tf)**

- Define the resources inside `main.tf` file: **[Entry of `ec2` main.tf](./modules/ec2/main.tf)**
---
## Step 7: Create the `iam_role` module.

- Define the resources inside `main.tf` file: **[Entry of `iam_role` main.tf](./modules/iam_role/main.tf)**

## Step 8: Apply Terraform resources

```bash
terraform init
terraform apply
```
---
## Notes
- Run the following AWS CLI command to verify the exact AMI name:
  ```bash
  aws ec2 describe-images \
    --owners amazon \
    --filters "Name=name,Values=al2023*" \
    --region us-east-1 \
    --query "Images[*].[ImageId,Name]" \
    --output table
  ```





  
