locals {
  ingress_rule = var.internal == true ? "internal" : "all"
}
