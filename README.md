<p align="center">
  <img src="./assets/logo.png" height="60"/>
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
  source  = "superblocksteam/terraform-google-superblocks"
  version = ">=1.0"

  project_id = var.project_id
  region     = var.region

  create_dns                 = false
  superblocks_agent_host_url = "<SUPERBLOCKS_AGENT_HOST_URL>"
  superblocks_agent_key      = "<SUPERBLOCKS_AGENT_KEY>"
}
```

#### Deploy
```
terraform init
terraform apply
```

#### Create the domain mapping manually
Once Superblocks Agent is deployed to Cloud Run, create the DNS record manually. Go to "Cloud Run -> Manage Custom Domains -> Add Mappings". Follow the instructions to

1. verify your domain
2. create the mapping
3. update DNS record

### Advanced Configuration
#### Private Networking
By default the Terraform module configures the Cloud Run service's ingress to allow all traffic. Limit ingress to allow internal traffic only by adding
```
internal = true
```

#### DNS
The module will try to creates a DNS record. For this to work successfully, you need to have a managed zone in the same project and set the `zone_name` and `record_name`. On the other hand, if you want to create the domain mapping manually, set `create_dns` to false and set `superblocks_agent_host_url`
```
zone_name   = "my-managed-zone-name-com"
record_name = "agent"
# or
create_dns                 = false
superblocks_agent_host_url = "https://agent.my-managed-zone.com"
```
#### Instance Sized
Configure the CPU & memory limits allocated to your Cloud Run instances use
```
container_requests_cpu    = "512m"
container_requests_memory = "1024Mi"
container_limits_cpu      = "1.0"
container_limits_memory   = "2048Mi"

```

#### Scaling
Google will automatically scale your Cloud Run instances based on traffic. To configure the minimum and maximum number of instances the agent can scale to, add
```
container_min_capacity    = "1"
container_max_capacity    = "5"
```

#### Other Configurable Options
```
variable "superblocks_agent_environment" {
  type        = string
  default     = "*"
  description = <<EOF
    Use this varible to differentiate Superblocks Agent running environment.
    Valid values are "*", "staging" and "production"
  EOF
}

variable "superblocks_agent_port" {
  type        = number
  default     = "8020"
  description = "The port number used by Superblocks Agent container instance"
}

variable "superblocks_agent_image" {
  type        = string
  default     = "gcr.io/terraform-testing-369414/agent"
  description = "The docker image used by Superblocks Agent container instance"
}

variable "name_prefix" {
  type        = string
  default     = "superblocks"
  description = "This will be prepended to the name of each resource created by this module"
}
```
