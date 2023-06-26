resource "vault_policy" "read_policy" {
  for_each = var.policy
  name     = each.value.name
  policy   = data.vault_policy_document.this[each.key].hcl
}

data "vault_policy_document" "this" {
  for_each = var.policy
  dynamic "rule" {
    for_each = each.value.rule
    content {
      path         = rule.value.path
      capabilities = rule.value.capabilities
      description  = rule.value.description
    }
  }
}