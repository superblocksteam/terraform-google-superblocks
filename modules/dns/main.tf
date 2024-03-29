data "google_dns_managed_zone" "superblocks" {
  name = var.zone_name
  project = var.project_id
}

locals {
  dns_name        = data.google_dns_managed_zone.superblocks.dns_name
  dns_name_no_dot = substr(local.dns_name, 0, length(local.dns_name) - 1)
}

resource "google_cloud_run_domain_mapping" "superblocks" {
  name     = "${var.record_name}.${local.dns_name_no_dot}"
  location = var.region

  metadata {
    namespace = var.project_id
  }

  spec {
    route_name = var.route_name
  }
}

resource "google_dns_record_set" "superblocks" {
  managed_zone = data.google_dns_managed_zone.superblocks.name
  name         = "${var.record_name}.${local.dns_name}"
  ttl          = 300
  type         = "CNAME"

  rrdatas = flatten([
    for _, status in google_cloud_run_domain_mapping.superblocks.status: [
      for _, rrs in status.resource_records:
      rrs.rrdata
    ]
  ])
}
