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

# Vault OIDC client
resource "vault_identity_oidc_assignment" "engineering" {
  name = "engineering-assignment"
  entity_ids = [
    vault_identity_entity.end_user.id,
  ]
  group_ids = [
    vault_identity_group.engineering.id,
  ]
}

resource "vault_identity_oidc_key" "engineering" {
  name               = "engineering-key"
  algorithm          = "RS256"
  verification_ttl   = "7200"
  rotation_period    = "3600"
  allowed_client_ids = ["*"]
}

resource "vault_identity_oidc_client" "boundary" {
  name = "boundary"
  redirect_uris = [
    "https://01c6c932-2742-4960-86b9-e5070a67d6cc.boundary.hashicorp.cloud:9200/v1/auth-methods/oidc:authenticate:callback",
    "https://01c6c932-2742-4960-86b9-e5070a67d6cc.boundary.hashicorp.cloud:8251/callback",
    "https://01c6c932-2742-4960-86b9-e5070a67d6cc.boundary.hashicorp.cloud:8080/callback"
  ]
  assignments = [
    vault_identity_oidc_assignment.engineering.name
  ]
  id_token_ttl     = 1800
  access_token_ttl = 3600
  key              = vault_identity_oidc_key.engineering.id
}

resource "vault_identity_oidc_scope" "users" {
  name = "user"
  template = jsonencode(
    {
      username = "{{identity.entity.name}}",
      # contact = [{
      #   email        = "{{identity.entity.metadata.email}}",
      #   phone_number = "{{identity.entity.metadata.phone_number}}",
      # }]
    }
  )
  description = "The user scope provides claims using Vault identity entity metadata"
}