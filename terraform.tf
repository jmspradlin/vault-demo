terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.17.0"
    }
  }

  required_version = ">= 1.1.0"
}