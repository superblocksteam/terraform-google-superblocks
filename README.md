<p align="center">
  <img src="https://raw.githubusercontent.com/superblocksteam/terraform-google-superblocks/main/assets/logo.png" height="60"/>
</p>

<h1 align="center">Superblocks Terraform Module - Google</h1>

<br/>

This document contains configuration and deployment details for deploying the Superblocks agent to Google Cloud.

## Deploy with Terraform

### Install Terraform

To install Terraform on MacOS
```
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

Terraform officially supports `MacOS|Windows|Linux|FreeBSD|OpenBSD|Solaris`
Check out this https://developer.hashicorp.com/terraform/downloads for more details

### Deploy Superblocks On-Premise-Agent

#### Create your Terraform file
To get started, you'll need a `superblocks_agent_key`. To generate an agent key, go to the [Superblocks On-Premise Agent Setup Wizard](https://app.superblocks.com/opas)
```
module "terraform_google_superblocks" {
  source  = "superblocksteam/superblocks/google"
  version = ">=0.1.0"

  project_id = "[GOOGLE_CLOUD_PROJECT_ID]"
  region     = "[GOOGLE_CLOUD_REGION]"

  superblocks_agent_key = "[YOUR_AGENT_KEY]"
  
  # Subdomain & domain in you Superblocks agent host url, for example superblocks.example.com
  sudomain = "[YOUR_SUBDOMAIN]"
  domain   = "[YOUR_DOMAIN]"
  
  # Google Cloud DNS Zone Name
  zone_name = "[YOUR_DOMAINS_CLOUD_DNS_ZONE_NAME]"
}
```
If you use Google Cloud DNS, find the `zone_name` for your `domain` by running `gcloud dns managed-zones list --filter "dns_name ~ ${domain}`. If you don't use Google Cloud DNS, see the [Custom Domain Mapping](https://cloud.google.com/run/docs/mapping-custom-domains) section for how you can manually configure the DNS for your agent.

#### Deploy
```
terraform init
terraform apply
```

### Advanced Configuration
#### Private Networking
The Terraform module configures your Cloud Run service's ingress to "Allow all traffic." You can update the ingress rules to "Only allow internal traffic" by adding the following to the Terraform module

```
internal = true
```

#### Custom Domain Mapping
By default, this module will try to configure a **custom domain** for your Cloud Run service, for example `subdomain.example.com`. This configures both the [Cloud Run Domain Mapping](https://cloud.google.com/run/docs/mapping-custom-domains#map) and a CNAME DNS record for your `domain`.

For this to work successfully, you must verify ownership of your `domain` with Google, and have a Cloud DNS Zone configured for the domain. To verify domain ownership, use the Google CLI command `gcloud domains verify ${domain}`. Find the Cloud DNS Zone Name for your domain by running `gcloud dns managed-zones list --filter "dns_name ~ ${domain}`.

If you don't use Google Cloud DNS, or want to manually configure the Domain Mapping, just disable DNS creation by adding the following to the Terraform module

```
create_dns = false
```

If you decide to manually set up a custom domain for your Cloud Run service, follow Google's instructions for [Mapping customer domains](https://cloud.google.com/run/docs/mapping-custom-domains#run)

#### Instance Sized
Configure the CPU & memory limits for your Cloud Run instances by adding the following variables to your Terraform module
```
container_requests_cpu    = "1"
container_requests_memory = "4Gi"
container_limits_memory   = "4Gi"

```

#### Scaling
Google will automatically scale your Cloud Run instances based on traffic. To configure the minimum and maximum number of instances the agent can scale to, add these variables to your Terraform module
```
container_min_capacity    = "1"
container_max_capacity    = "5"
```

#### Other Configurable Options
```
variable "superblocks_agent_environment" {
  type        = string
  default     = "*"
  description = <<ENVIRONMENT
    Use this varible to differentiate Superblocks Agent running environment.
    Valid values are "*", "staging" and "production"
  ENVIRONMENT
}

variable "superblocks_agent_image" {
  type        = string
  default     = "us-east1-docker.pkg.dev/superblocks-registry/superblocks/agent"
  description = "The docker image used by Superblocks Agent container instance"
}

variable "container_cpu_throttling" {
  type        = bool
  default     = false
  description = "When it's false, CPU is always allocated."
}

variable "name_prefix" {
  type        = string
  default     = "superblocks"
  description = "This will be prepended to the name of each resource created by this module"
}
```
