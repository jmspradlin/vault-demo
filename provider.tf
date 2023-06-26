provider "vault" {
  namespace        = "admin"
  address          = "https://vault-cluster-public-vault-1a207c4e.405d52c1.z1.hashicorp.cloud:8200"
  skip_child_token = true
  auth_login {
    path      = "auth/approle/login"
    namespace = "admin"


    parameters = {
      role_id   = var.login_approle_role_id
      secret_id = var.login_approle_secret_id
    }
  }
}