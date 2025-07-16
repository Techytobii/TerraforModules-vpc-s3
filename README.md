# TerraformModules-vpc-s3

## Mini Project: Terraform Modules - VPC and S3 Bucket with Backend Storage

## Objectives

- Develop reusable Terraform modules for infrastructure provisioning.
- Deploy a Virtual Private Cloud (VPC) with subnets.
- Create an Amazon S3 bucket for Terraform state storage.
- Implement remote backend configuration in Terraform.


## Prerequisites

- Terraform installed ([Download Terraform](https://developer.hashicorp.com/terraform/downloads))
- AWS Account with permissions to create VPCs and S3 buckets
- AWS CLI configured
- Git installed


## Project Structure

```
/terraform
  /modules
    /vpc
      - main.tf
      - variables.tf
      - outputs.tf
    /s3
      - main.tf
      - variables.tf
      - outputs.tf
  /environments
    /dev
      - main.tf
      - backend.tf
      - variables.tf
      - outputs.tf
README.md
```

![Project Structure](./img/project-structure.png)

## Backend Configuration Example

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "terraform.tfstate"
    region = "us-west-2"
    encrypt = true
  }
}
```

![Backend Config](./img/backend-tf.png)

## Deployment Steps

```bash
git clone https://github.com/Techytobii/TerraforModules-vpc-s3.git
cd TerraforModules-vpc-s3
terraform init
terraform plan
terraform apply
```
![terraform-init](./img/terraform-init.png)

## Outputs

- VPC ID
- Public Subnet ID
- S3 Bucket Name


## Author

Oluwatobi Olofinkuade  
GitHub: [https://github.com/Techytobii/TerraforModules-vpc-s3](https://github.com/Techytobii/TerraforModules-vpc-s3)

## Code Files

### modules/vpc/main.tf
```hcl
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "public" {
  vpc_id             = aws_vpc.main.id
  cidr_block         = var.public_subnet_cidr
  availability_zone  = var.availability_zone
}
```

### modules/vpc/variables.tf
```hcl
variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
variable "availability_zone" {}
```

### modules/vpc/outputs.tf
```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}
```

### modules/s3/main.tf
```hcl
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = "private"
}
```

### modules/s3/variables.tf
```hcl
variable "bucket_name" {}
```

### modules/s3/outputs.tf
```hcl
output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}
```

### environments/dev/backend.tf
```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "terraform/state/terraform.tfstate"
    region = "us-west-2"
  }
}
```

### environments/dev/main.tf
```hcl
module "vpc" {
  source                = "../../modules/vpc"
  vpc_cidr              = "10.0.0.0/16"
  public_subnet_cidr    = "10.0.1.0/24"
  availability_zone     = "us-west-2a"
}

module "s3" {
  source       = "../../modules/s3"
  bucket_name  = "my-terraform-state-bucket"
}
```

### environments/dev/variables.tf
```hcl
# Environment-specific variables if needed
```

### environments/dev/outputs.tf
```hcl
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "s3_bucket_name" {
  value = module.s3.bucket_name
}
```
