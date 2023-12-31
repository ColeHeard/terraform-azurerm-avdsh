###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###
### Locals
###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###>-<###hese
# Calculates if an extension type is needed for this pool's sessionhosts.
locals {
  extensions = {
    domain_join = var.domain != null ? 1 : 0
    mmaagent    = var.workspace_id != null ? 1 : 0
  }
}
# Determines the default sessionhost size if unspecified. 
locals {
  name = "${var.pool_input.v.region_prefix}${var.pool_input.v.workspace_prefix}${var.pool_input.v.pool_type_prefix}${var.pool_input.v.pool_number}-${format("%02d", var.vmnumber)}${var.side}"
}
# Dynamic tags - to-do.
locals {
  tags = {
    Platform = "Azure Virtual Desktop"
    Function = terraform.workspace == "default" ? "Production" : "${terraform.workspace}"
  }
}