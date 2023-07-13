resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "vault_policy" "boundary" {
  for_each = var.boundary_policy
  name     = "boundary-${each.value.name}"
  policy   = data.vault_policy_document.boundary[each.key].hcl
}

data "vault_policy_document" "boundary" {
  for_each = var.boundary_policy
  dynamic "rule" {
    for_each = each.value.rule
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
  data_json = <<EOT
{
  "policies": [vault_policy.boundary],
  "password": random_password.password.result,
  "token_ttl": "1h"
}
EOT
}