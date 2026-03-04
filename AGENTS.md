# AGENTS.md - Terraform Google Superblocks

## Overview

Customer-facing Terraform module that deploys the Superblocks **On-Premise Agent (OPA)** on Google Cloud Platform. The agent runs on **Cloud Run** with optional custom domain mapping and Cloud DNS configuration. Published to the Terraform Registry as [`superblocksteam/superblocks/google`](https://registry.terraform.io/modules/superblocksteam/superblocks/google).

This module deploys the Docker image maintained in the `orchestrator`/`agent` repository.

## Engineering-Wide Context

For broader Superblocks standards (architecture, observability, incident workflow):

```bash
gh api repos/superblocksteam/engineering/contents/AGENTS.md --jq '.content' | base64 --decode
```

## Cross-Repo Sync

This repository is one of three parallel OPA deployment modules:

| Repository | Cloud | Compute |
|---|---|---|
| `terraform-aws-superblocks` | AWS | ECS Fargate + ALB |
| `terraform-azure-superblocks` | Azure | Container Apps |
| **terraform-google-superblocks** (this repo) | GCP | Cloud Run |

Changes to one should be accompanied by corresponding changes in the others where applicable (agent env vars, new features, documentation). See the engineering repo's `.cursor/rules/opa-terraform-modules.mdc` for details.

## Repository Structure

```
terraform-google-superblocks/
├── main.tf              # Root module orchestrating sub-modules
├── variables.tf         # Input variables
├── locals.tf            # Computed values
├── provider.tf          # Terraform/provider version constraints
├── modules/
│   ├── cloud-run/       # Cloud Run service, IAM, health probes, auto-scaling
│   └── dns/             # Cloud Run domain mapping, Cloud DNS record
└── examples/
    ├── simple-public-agent/  # Basic public deployment with DNS
    ├── custom-url/           # Custom domain without auto DNS
    └── complete/             # Full configuration
```

## Commands

```bash
terraform fmt -recursive   # Format all files
terraform validate         # Validate configuration
terraform plan             # Preview changes
terraform apply            # Apply changes

pre-commit install         # One-time setup
pre-commit run --all-files # Run formatting hooks
```

## Module Architecture

The root module (`main.tf`) conditionally creates resources via sub-modules:

1. **Cloud Run** (default, `deploy_in_cloud_run = true`) -- Cloud Run service with agent container, IAM binding, health probes, auto-scaling
2. **DNS** (optional, `create_dns = true`) -- Cloud Run domain mapping and Cloud DNS CNAME record

The Cloud Run module handles ingress control (public vs internal-only) and configures all `SUPERBLOCKS_ORCHESTRATOR_*` environment variables for the agent container.

## Code Style

### File Naming

| File | Purpose |
|------|---------|
| `main.tf` | Primary resources |
| `variables.tf` | Input variables |
| `outputs.tf` | Output values |
| `locals.tf` | Computed local values |
| `provider.tf` | Provider and Terraform version constraints |

### Variable Definitions

```hcl
variable "superblocks_agent_key" {
  type        = string
  sensitive   = true
  description = "Superblocks agent key"
  validation {
    condition     = length(var.superblocks_agent_key) >= 10
    error_message = "The agent key must be at least 10 characters."
  }
}
```

## Key Variables

| Variable | Default | Description |
|---|---|---|
| `superblocks_agent_key` | (required) | Agent authentication key |
| `project_id` | (required) | GCP project ID |
| `region` | (required) | GCP region |
| `domain` | (required) | Domain for custom domain mapping |
| `subdomain` | `"agent"` | Subdomain prefix |
| `zone_name` | `""` | Cloud DNS managed zone name |
| `create_dns` | `true` | Create DNS records |
| `internal` | `false` | Restrict to internal traffic |
| `container_min_capacity` | `1` | Min Cloud Run instances |
| `container_max_capacity` | `5` | Max Cloud Run instances |
| `container_requests_cpu` | `"1"` | CPU request |
| `container_requests_memory` | `"4Gi"` | Memory request |

## Provider Requirements

- Terraform: `>= 1.0`
- Google provider: `>= 5.0.0`

## Conventions

- Use **allowlist** / **denylist** (not whitelist/blacklist)
- Keep lists alphabetically ordered where order is not meaningful
- Never commit secrets or `.tfvars` files containing credentials
- Mark sensitive variables with `sensitive = true`
