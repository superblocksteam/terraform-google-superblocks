<h1 align="center">
  <img src="https://raw.githubusercontent.com/superblocksteam/terraform-google-superblocks/main/assets/logo.png" style="height:60px"/>
</h1>

<h1 align="center">Superblocks Terraform Module - Google</h1>

<br/>

This document contains configuration and deployment details for deploying the Superblocks agent to Google Cloud.

## Deploy with Terraform

### Install Terraform

To install Terraform on MacOS

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

Terraform officially supports `MacOS|Windows|Linux|FreeBSD|OpenBSD|Solaris`
Check out this https://developer.hashicorp.com/terraform/downloads for more details

### Deploy Superblocks On-Premise-Agent

#### Create your Terraform file

To get started, you'll need a `superblocks_agent_key`. To generate an agent key, go to the [Superblocks On-Premise Agent Setup Wizard](https://app.superblocks.com/opas)

```terraform
module "terraform_google_superblocks" {
  source  = "superblocksteam/superblocks/google"
  version = ">=0.1.0"

  project_id = "[GOOGLE_CLOUD_PROJECT_ID]"
  region     = "[GOOGLE_CLOUD_REGION]"

  superblocks_agent_key = "[YOUR_AGENT_KEY]"

  # Subdomain & domain in your Superblocks agent host url, for example superblocks.example.com
  sudomain = "[YOUR_SUBDOMAIN]"
  domain   = "[YOUR_DOMAIN]"

  # Google Cloud DNS Zone Name
  zone_name = "[YOUR_DOMAINS_CLOUD_DNS_ZONE_NAME]"
}
```

If you are in the **[EU region](https://eu.superblocks.com)**, ensure that

```terraform
superblocks_agent_data_domain = "eu.superblocks.com"
```

is set in your configuration in the module block.

If you use Google Cloud DNS, find the `zone_name` for your `domain` by running `gcloud dns managed-zones list --filter "dns_name ~ ${domain}`. If you don't use Google Cloud DNS, see the [Custom Domain Mapping](https://cloud.google.com/run/docs/mapping-custom-domains) section for how you can manually configure the DNS for your agent.

#### Deploy

```bash
terraform init
terraform apply
```

### Advanced Configuration

#### Private Networking

The Terraform module configures your Cloud Run service's ingress to "Allow all traffic." You can update the ingress rules to "Only allow internal traffic" by adding the following to the Terraform module

```terraform
internal = true
```

#### Custom Domain Mapping

By default, this module will try to configure a **custom domain** for your Cloud Run service, for example `subdomain.example.com`. This configures both the [Cloud Run Domain Mapping](https://cloud.google.com/run/docs/mapping-custom-domains#map) and a CNAME DNS record for your `domain`.

For this to work successfully, you must verify ownership of your `domain` with Google, and have a Cloud DNS Zone configured for the domain. To verify domain ownership, use the Google CLI command `gcloud domains verify ${domain}`. Find the Cloud DNS Zone Name for your domain by running `gcloud dns managed-zones list --filter "dns_name ~ ${domain}`.

If you don't use Google Cloud DNS, or want to manually configure the Domain Mapping, just disable DNS creation by adding the following to the Terraform module

```terraform
create_dns = false
```

If you decide to manually set up a custom domain for your Cloud Run service, follow Google's instructions for [Mapping customer domains](https://cloud.google.com/run/docs/mapping-custom-domains#run)

#### Instance Sized

Configure the CPU & memory limits for your Cloud Run instances by adding the following variables to your Terraform module

```terraform
container_requests_cpu    = "1"
container_requests_memory = "4Gi"
container_limits_memory   = "4Gi"

```

#### Scaling

Google will automatically scale your Cloud Run instances based on traffic. To configure the minimum and maximum number of instances the agent can scale to, add these variables to your Terraform module

```terraform
container_min_capacity    = "1"
container_max_capacity    = "5"
```

#### Other Configurable Options

```terraform
variable "superblocks_agent_environment" {
  type        = string
  default     = "*"
  description = "Use this varible to differentiate Superblocks Agent running environment. Valid values are '*', 'staging' and 'production'"
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

variable "superblocks_grpc_msg_res_max" {
  type        = string
  default     = "100000000"
  description = "The maximum message size in bytes allowed to be sent by the gRPC server. This is used to prevent malicious clients from sending large messages to cause memory exhaustion."
}

variable "superblocks_grpc_msg_req_max" {
  type        = string
  default     = "30000000"
  description = "The maximum message size in bytes allowed to be received by the gRPC server. This is used to prevent malicious clients from sending large messages to cause memory exhaustion."
}

variable "superblocks_timeout" {
  type        = string
  default     = "10000000000"
  description = "The maximum amount of time in milliseconds before a request is aborted. This applies for http requests against the Superblocks server and does not apply to the execution time limit of a workload."
}

variable "superblocks_log_level" {
  type        = string
  default     = "info"
  description = "Logging level for the superblocks agent. Accepted values are 'debug', 'info', 'warn', 'error', 'fatal', 'panic'."
}

variable "superblocks_agent_handle_cors" {
  type        = bool
  default     = true
  description = "Whether to handle CORS requests, this will accept all requests from any origin."
}

variable "superblocks_additional_env_vars" {
  type       = map(string)
  default    = {}
  sensitive  = true
  description = "Additional environment variables to specify for the Superblocks Agent container."
}
```
