terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.17.0"
    }
    # boundary = {
    #   source = "hashicorp/boundary"
    #   version = "1.1.8"
    # }
  }

  required_version = ">= 1.1.0"
  cloud {
    organization = "jeff-spradlin-org"

    workspaces {
      name = "vault-demo-boundary"
    }
  }
}

provider "boundary" {
  addr                            = var.boundary_addr
  password_auth_method_login_name = jsondecode(data.vault_kv_secret.boundary_auth.data.data).password_auth_method_login_name
  password_auth_method_password   = jsondecode(data.vault_kv_secret.boundary_auth.data.data).password_auth_method_password
}