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

variable "project_id" {
  description = "Project ID (also used for the Apigee Organization)"
  type        = string
}

variable "cloud_run_service_name" {
  description = "Name of the Cloud Run service for alu-api"
  type        = string
  default     = "alu-api"
}

variable "cloud_run_location" {
  description = "Location of Cloud Run for alu-api service"
  type        = string
  default     = "asia-south1"
}

variable "cloud_run_min_instance_count" {
  description = "Minimum number of instance of alu-api service"
  type        = number
  default     = 1
}

variable "cloud_run_max_instance_count" {
  description = "Maximum number of instance of alu-api service"
  type        = number
  default     = 20
}

variable "ax_region" {
  description = "GCP region for storing Apigee analytics data (see https://cloud.google.com/apigee/docs/api-platform/get-started/install-cli)."
  type        = string
  default     = "asia-south1"
}

variable "apigee_billing_type" {
  description = "Billing type of the Apigee organization (Valid values are EVALUATION, PAYG, and SUBSCRIPTION)"
  type        = string
  default     = "PAYG"
}

variable "apigee_instances" {
  description = "Apigee Instances (only one instance for EVAL orgs)."
  type = map(object({
    region       = string
    ip_range     = string
    environments = list(string)
  }))
  default = {
    as1-instance-dev = {
      region       = "asia-south1"
      ip_range     = "10.0.0.0/22"
      environments = ["prod"]
    }
  }

}

variable "apigee_environments" {
  description = "Apigee Environments."
  type = map(object({
    display_name = optional(string)
    description  = optional(string)
    node_config = optional(object({
      min_node_count = optional(number)
      max_node_count = optional(number)
    }))
    iam       = optional(map(list(string)))
    envgroups = list(string)
    type      = optional(string)
  }))
  default = {
    prod = {
      display_name = "prod"
      description  = "Environment created by apigee/terraform-modules"
      node_config  = null
      iam          = null
      envgroups    = ["prod"]
      type         = "INTERMEDIATE"
    }
  }

}

variable "exposure_subnets" {
  description = "Subnets for exposing Apigee services"
  type = list(object({
    name               = string
    ip_cidr_range      = string
    region             = string
    secondary_ip_range = map(string)
  }))
  default = [
    {
      name               = "apigee-exposure"
      ip_cidr_range      = "10.100.0.0/24"
      region             = "asia-south1"
      secondary_ip_range = null
    }
  ]

}

variable "network" {
  description = "VPC name"
  type        = string
  default     = "apigee-network"
}

variable "peering_range" {
  description = "Peering CIDR range"
  type        = string
  default     = "10.0.0.0/22"
}

variable "support_range" {
  description = "Support CIDR range of length /28 (required by Apigee for troubleshooting purposes)."
  type        = string
  default     = "10.1.0.0/28"
}

variable "billing_account" {
  description = "Billing account id."
  type        = string
  default     = null
}

variable "project_parent" {
  description = "Parent folder or organization in 'folders/folder_id' or 'organizations/org_id' format."
  type        = string
  default     = null
  validation {
    condition     = var.project_parent == null || can(regex("(organizations|folders)/[0-9]+", var.project_parent))
    error_message = "Parent must be of the form folders/folder_id or organizations/organization_id."
  }
}

variable "project_create" {
  description = "Create project. When set to false, uses a data source to reference existing project."
  type        = bool
  default     = false
}

