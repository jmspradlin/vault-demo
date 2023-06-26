terraform {
  required_providers {
    vault = {
      source  = "hashicorp/terraform-provider-vault"
      version = "~> 2.9.0"
    }
  }

  required_version = ">= 1.1.0"

  cloud {
    organization = "jeff-spradlin-org"

    workspaces {
      name = "vault-demo-adopt"
    }
  }


}