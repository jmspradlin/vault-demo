boundary_policy = {
  oidc = {
    name = "oidc-auth"
    rule = {
      rule1 = {
        path         = "identity/oidc/provider/my-provider/authorize"
        capabilities = ["read"]
        description  = "OIDC policy granting the user read capabilities on the authorization endpoint."
      }
    }
  }
}