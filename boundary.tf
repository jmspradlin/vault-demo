resource "boundary_auth_method_oidc" "this" {
  scope_id           = "global" #var.boundary_scope_id
  issuer             = vault_identity_oidc_provider.this.issuer
  client_id          = data.vault_identity_oidc_client_creds.boundary.client_id
  client_secret      = data.vault_identity_oidc_client_creds.boundary.client_secret
  signing_algorithms = ["RS256"]
  api_url_prefix     = "${var.boundary_addr}"
  claims_scopes      = ["groups", "user"]
  max_age            = 20
  name               = "Vault OIDC Provider"
  state              = "active-public"
}