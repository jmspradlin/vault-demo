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
  readkv = {
    name = "read-kv"
    rule = {
      rule1 = {
        path         = "secret/kv/*"
        capabilities = ["read", "list"]
        description  = "Read KV policy"
      }
    }
  }
  createkv = {
    name = "create-kv"
    rule = {
      rule1 = {
        path         = "secret/kv"
        capabilities = ["create","read", "update", "list"]
        description  = "Everything Except Delete"
      }
    }
  }
  createaws = {
    name = "create-aws"
    rule = {
      rule1 = {
        path         = "secret/aws"
        capabilities = ["create","read", "update", "list"]
        description  = "Everything Except Delete"
      }
    }
  }
}