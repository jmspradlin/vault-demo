resource "vault_policy" "read_policy" {
  name = "read-policy"

  policy = <<EOT
path "sys/policy" {
  capabilities = ["read", "list"]
}

path "sys/policy/*" {
  capabilities = ["read", "list"]
}

path "sys/policies/acl/*" {
  "capabilities" = ["read", "list"]
}
EOT
}