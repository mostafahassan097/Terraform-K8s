terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "${aws_eks_cluster.my-eks-cluster.arn}"
}

/*# Backend must remain commented until the Bucket
 and the DynamoDB table are created. 
 After the creation you can uncomment it,
 run "terraform init" and then "terraform apply" */

 terraform {
   backend "s3" {
     bucket         = "eksmomo-terraform-state-backend"
     key            = "terraform.tfstate"
     region         = "eu-west-1"
     dynamodb_table = "terraform_state"
   }
}