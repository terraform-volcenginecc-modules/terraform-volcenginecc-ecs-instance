variable "zone_id" {
  type        = string
  description = "Target zone. GPU, bare-metal, and all selected x86 instance types must be available in this zone."
}

variable "image_id" {
  type        = string
  description = "Existing image ID compatible with all selected instance types."
}

variable "instance_type" {
  type        = string
  description = "Existing general-purpose instance type available in zone_id and compatible with image_id."
}

variable "subnet_id" {
  type        = string
  description = "Existing subnet ID."
}

variable "security_group_id" {
  type        = string
  description = "Existing security group ID."
}

variable "key_pair_name" {
  type        = string
  description = "Existing key pair name."
}

variable "web_private_ip" {
  type        = string
  description = "An optional unallocated IPv4 address in subnet_id for the web node."
  default     = null
}

variable "session_role_name" {
  type        = string
  description = "Existing IAM role name approved for the Cloud Assistant/session-management workflow."
}

variable "gpu_instance_type" {
  type        = string
  description = "A GPU instance type available to the account in zone_id."
}

variable "bare_metal_instance_type" {
  type        = string
  description = "A bare-metal instance type available to the account in zone_id."
}

variable "hpc_cluster_id" {
  type        = string
  description = "Existing HPC cluster ID when the selected GPU instance type requires it."
  default     = null
}
