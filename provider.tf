provider "vault" {
  namespace        = "admin"
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