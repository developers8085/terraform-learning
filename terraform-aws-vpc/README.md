# terraform-learning

### ***Full VPC Creation Using Terraform Template***
#### What is VPC ?
    VPC is a AWS service(Amazon Virtual Private Cloud). Which help in creating vitual private network within AWS region. 
    Where you can launch your AWS resource within VPC. They protected from Open internet.
 #### What is Terraform ?
    Terraform is a multi-cloud (IaC) Infrastructure as Code software by HashiCorp written in Go Language using (HCL) HashiCorp Config 
    Language.An open source command line tool that can be used to provide an infrastructure on many different platforms and services 
    such as IBM, AWS, GCP,Azure, OpenStack, VMware and more.


  Terraform and AWS CLI must be installed locally to run the template. If you not installed terraform follow [installation link](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) and for AWS CLI follow [AWS CLI Install](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html). 
  
   First AWS provider should be setup
   ```
    terraform {
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 4.0"
        }
     }
    }
    provider "aws" {
      region = "valid aws region"
      access_key = "access-key"
      secret_key = "secret-key"
    }
   ```
   There are couple ways to interact with AWS environment. But here I'm using simple way by hardcoding access-key and secret-key. Please do not commit 
   these details to github or any other public domain.
   
   ## Running Terrform commands
      terraform init
      terraform plan
      terraform apply
