policy = {
  readpolicies = {
    name = "read-policy"
    rule = {
      rule1 = {
        path         = "sys/policy"
        capabilities = ["read", "list"]
        description  = "Root Read/List"
      }
      rule2 = {
        path         = "sys/policy/*"
        capabilities = ["read", "list"]
        description  = "Child Read/List"
      }
      rule3 = {
        path         = "sys/policies/acl/*"
        capabilities = ["read", "list"]
        description  = "ACL permissions"
      }
    }
  }
}