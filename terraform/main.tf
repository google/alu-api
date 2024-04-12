# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

provider "google" {
  project = var.project_id
}

resource "google_project_service" "iam" {
  service                    = "iam.googleapis.com"
  disable_on_destroy         = false
  disable_dependent_services = false
}

resource "google_project_service" "run" {
  service                    = "run.googleapis.com"
  disable_on_destroy         = false
  disable_dependent_services = false
}

resource "google_project_service" "cloud_spanner" {
  service                    = "spanner.googleapis.com"
  disable_on_destroy         = false
  disable_dependent_services = false
}

resource "google_service_account" "api_runner" {
  account_id = "alu-api-runner"
  depends_on = [google_project_service.iam]
}

resource "google_service_account" "apigee_proxy" {
  account_id = "apigee-proxy"
  depends_on = [google_project_service.iam]
}

resource "google_cloud_run_v2_service" "main" {
  name     = var.cloud_run_service_name
  location = var.cloud_run_location
  client   = "terraform"

  template {
    containers {
      image = "asia-south1-docker.pkg.dev/bit-anthrokrishi/services/alu-api:latest"
      resources {
        limits = {
          "cpu" : "2"
          "memory" : "4096Mi"
        }
      }
    }
    scaling {
      min_instance_count = var.cloud_run_min_instance_count
      max_instance_count = var.cloud_run_max_instance_count
    }
    service_account = google_service_account.api_runner.email
  }

  depends_on = [google_project_service.run, google_project_service.cloud_spanner]
}

resource "google_cloud_run_v2_service_iam_member" "member" {
  location = google_cloud_run_v2_service.main.location
  name     = google_cloud_run_v2_service.main.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.apigee_proxy.email}"
}


locals {
  subnet_region_name = { for subnet in var.exposure_subnets :
    subnet.region => "${subnet.region}/${subnet.name}"
  }
}

module "project" {
  source          = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/project?ref=v28.0.0"
  name            = var.project_id
  parent          = var.project_parent
  billing_account = var.billing_account
  project_create  = var.project_create
  services = [
    "apigee.googleapis.com",
    "cloudkms.googleapis.com",
    "compute.googleapis.com",
    "servicenetworking.googleapis.com"
  ]
}

module "vpc" {
  source     = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/net-vpc?ref=v28.0.0"
  project_id = module.project.project_id
  name       = var.network
  subnets    = var.exposure_subnets
  psa_config = {
    ranges = {
      apigee-range         = var.peering_range
      apigee-support-range = var.support_range
    }
  }
}

module "nip-development-hostname" {
  source       = "github.com/apigee/terraform-modules//modules/nip-development-hostname?ref=v0.21.0"
  project_id   = module.project.project_id
  address_name = "apigee-external"
}

module "apigee-x-core" {
  source              = "github.com/apigee/terraform-modules//modules/apigee-x-core?ref=v0.21.0"
  project_id          = module.project.project_id
  ax_region           = var.ax_region
  billing_type        = var.apigee_billing_type
  apigee_environments = var.apigee_environments
  apigee_instances    = var.apigee_instances
  network             = module.vpc.network.id
  apigee_envgroups = {
    prod = {
      hostnames = [module.nip-development-hostname.hostname]
    }
  }
}

module "apigee-x-bridge-mig" {
  for_each    = var.apigee_instances
  source      = "github.com/apigee/terraform-modules//modules/apigee-x-bridge-mig?ref=v0.21.0"
  project_id  = module.project.project_id
  network     = module.vpc.network.id
  subnet      = module.vpc.subnet_self_links[local.subnet_region_name[each.value.region]]
  region      = each.value.region
  endpoint_ip = module.apigee-x-core.instance_endpoints[each.key]
}

module "mig-l7xlb" {
  source          = "github.com/apigee/terraform-modules//modules/mig-l7xlb?ref=v0.21.0"
  project_id      = module.project.project_id
  name            = "apigee-xlb"
  backend_migs    = [for _, mig in module.apigee-x-bridge-mig : mig.instance_group]
  ssl_certificate = [module.nip-development-hostname.ssl_certificate]
  external_ip     = module.nip-development-hostname.ip_address
}
