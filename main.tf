resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "vault_policy" "boundary" {
  name     = "boundary-${var.boundary_policy.name}"
  policy   = data.vault_policy_document.boundary.hcl
}

data "vault_policy_document" "boundary" {
  dynamic "rule" {
    for_each = var.boundary_policy.rule
    content {
      path         = rule.value.path
      capabilities = rule.value.capabilities
      description  = rule.value.description
    }
  }
}

resource "vault_generic_endpoint" "end_user" {
  path = "auth/userpass/users/end-user"
  ignore_absent_fields = true
  data_json = jsonencode({
    "policies"="boundary-${var.boundary_policy.name}",
    "password"="${random_password.password.result}",
    "token_ttl"="1h"
    })
}
