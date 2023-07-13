data "vault_auth_backend" "userpass" {
  path = "userpass"
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "vault_policy" "boundary" {
  name   = "boundary-${var.boundary_policy.name}"
  policy = data.vault_policy_document.boundary.hcl
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
  path                 = "auth/userpass/users/end-user"
  ignore_absent_fields = true
  data_json = jsonencode({
    "policies"  = "boundary-${var.boundary_policy.name}",
    "password"  = "${random_password.password.result}",
    "token_ttl" = "1h"
  })
}

resource "vault_identity_entity" "end_user" {
  name = "end-user"
}

resource "vault_identity_group" "engineering" {
  name = "engineering"
}

resource "vault_identity_group_member_entity_ids" "members" {
  member_entity_ids = [vault_identity_entity.end_user.id]
  group_id          = vault_identity_group.engineering.id
}

resource "vault_identity_entity_alias" "end_user" {
  name           = "end-user"
  mount_accessor = data.vault_auth_backend.userpass.accessor
  canonical_id   = vault_identity_entity.end_user.id
}