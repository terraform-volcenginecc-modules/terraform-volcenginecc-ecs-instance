variable "zone_id" {
  type        = string
  description = "Availability zone for the existing subnet and target instance type."
}

variable "image_id" {
  type        = string
  description = "Existing Linux image ID."
}

variable "instance_type" {
  type        = string
  description = "Existing instance type available in zone_id and compatible with image_id."
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
