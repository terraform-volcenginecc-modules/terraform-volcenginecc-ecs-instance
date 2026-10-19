variable "instances" {
  type = map(object({
    instance_name      = string
    instance_type      = string
    zone_id            = string
    image_id           = string
    subnet_id          = string
    security_group_ids = set(string)
    system_volume = object({
      volume_type                     = string
      size                            = number
      delete_with_instance            = optional(bool, true)
      snapshot_id                     = optional(string)
      extra_performance_type_id       = optional(string)
      extra_performance_iops          = optional(number)
      extra_performance_throughput_mb = optional(number)
    })
    data_volumes = optional(map(object({
      volume_type                     = string
      size                            = number
      delete_with_instance            = optional(bool, true)
      snapshot_id                     = optional(string)
      extra_performance_type_id       = optional(string)
      extra_performance_iops          = optional(number)
      extra_performance_throughput_mb = optional(number)
    })), {})
    tags                          = optional(map(string), {})
    description                   = optional(string)
    hostname                      = optional(string)
    project_name                  = optional(string)
    key_pair_name                 = optional(string)
    private_ip_address            = optional(string)
    private_ip_addresses          = optional(set(string))
    ipv_6_address_count           = optional(number)
    user_data                     = optional(string)
    role_names                    = optional(set(string), [])
    install_run_command_agent     = optional(bool)
    hpc_cluster_id                = optional(string)
    image_release_version         = optional(string)
    keep_image_credential         = optional(bool)
    security_enhancement_strategy = optional(string)
    instance_charge_type          = optional(string)
    period                        = optional(number)
    period_unit                   = optional(string)
    auto_pay                      = optional(bool)
    auto_renew                    = optional(bool)
    auto_renew_period             = optional(number)
    spot_strategy                 = optional(string, "NoSpot")
    spot_price_limit              = optional(number)
    eip = optional(object({
      bandwidth_mbps            = optional(number)
      bandwidth_package_id      = optional(string)
      charge_type               = optional(string)
      isp                       = optional(string)
      release_with_instance     = optional(bool, false)
      security_protection_types = optional(set(string))
    }))
  }))
  description = "ECS instances keyed by stable logical names. Changing a map key changes the Terraform resource address. Credentials, VPC, subnet, security groups, image, key pair, and IAM roles are caller-owned."

  validation {
    condition = alltrue([
      for instance in values(var.instances) :
      length(trimspace(instance.instance_name)) > 0 &&
      can(regex("^[A-Za-z][A-Za-z0-9_.-]{0,127}$", instance.instance_name)) &&
      length(trimspace(instance.instance_type)) > 0 &&
      length(trimspace(instance.zone_id)) > 0 &&
      length(trimspace(instance.image_id)) > 0 &&
      length(trimspace(instance.subnet_id)) > 0 &&
      length(instance.security_group_ids) > 0 &&
      length(instance.security_group_ids) <= 5
    ])
    error_message = "Every instance requires non-empty name, type, zone_id, image_id, subnet_id, and one to five security_group_ids."
  }

  validation {
    condition = alltrue([
      for instance in values(var.instances) :
      instance.private_ip_address == null ? true : can(cidrhost("${instance.private_ip_address}/32", 0))
    ])
    error_message = "private_ip_address must be a valid IPv4 address when provided."
  }

  validation {
    condition = alltrue([
      for instance in values(var.instances) :
      instance.system_volume.size >= 10 && instance.system_volume.size <= 32768 &&
      contains(["ESSD_PL0", "ESSD_FlexPL", "TSSD_TL0", "PL0ESSD_FlexPL"], instance.system_volume.volume_type) &&
      alltrue([
        for volume in values(instance.data_volumes) :
        volume.size >= 10 && volume.size <= 32768 &&
        contains(["ESSD_PL0", "ESSD_FlexPL", "TSSD_TL0", "PL0ESSD_FlexPL"], volume.volume_type)
      ])
    ])
    error_message = "System and data volumes must use a supported volume type and have a size between 10 and 32768 GiB."
  }

  validation {
    condition = alltrue([
      for instance in values(var.instances) :
      length(instance.data_volumes) <= 15
    ])
    error_message = "Each instance supports at most 15 data volumes."
  }

  validation {
    condition = alltrue([
      for instance in values(var.instances) :
      contains(["NoSpot", "SpotWithPriceLimit", "SpotAsPriceGo"], instance.spot_strategy) &&
      (instance.spot_strategy == "SpotWithPriceLimit" ? try(instance.spot_price_limit > 0, false) : instance.spot_price_limit == null)
    ])
    error_message = "spot_price_limit must be set only for SpotWithPriceLimit and must be greater than zero."
  }

  validation {
    condition = alltrue([
      for instance in values(var.instances) :
      instance.eip == null ? true : (
        try(instance.eip.bandwidth_mbps == null ? true : (instance.eip.bandwidth_mbps >= 1 && instance.eip.bandwidth_mbps <= 500), true) &&
        try(instance.eip.charge_type == null ? true : contains(["PayByBandwidth", "PayByTraffic", "PrePaid"], instance.eip.charge_type), true) &&
        try(instance.eip.charge_type != "PayByTraffic" ? true : (instance.eip.bandwidth_mbps == null ? true : instance.eip.bandwidth_mbps <= 200), true)
      )
    ])
    error_message = "EIP bandwidth_mbps must be 1 to 500 (at most 200 for PayByTraffic), and charge_type must be PayByBandwidth, PayByTraffic, or PrePaid."
  }

  validation {
    condition = alltrue([
      for instance in values(var.instances) :
      instance.user_data == null ? true : (
        !can(regex("(?i)(access[_-]?key|secret[_-]?key|aws_access_key_id|aws_secret_access_key|volcengine_access_key|volcengine_secret_key|akia[0-9a-z]{16}|aklt[0-9a-z]+)", instance.user_data)) &&
        !can(regex("(?i)(access[_-]?key|secret[_-]?key|aws_access_key_id|aws_secret_access_key|volcengine_access_key|volcengine_secret_key|akia[0-9a-z]{16}|aklt[0-9a-z]+)", try(base64decode(instance.user_data), "")))
      )
    ])
    error_message = "user_data must not contain plaintext credentials, including Base64-encoded credentials."
  }

  validation {
    condition = alltrue([
      for instance in values(var.instances) :
      length(instance.tags) <= 50 && alltrue([for key in keys(instance.tags) : length(trimspace(key)) > 0])
    ])
    error_message = "Each instance supports at most 50 tags and tag keys must not be empty."
  }
}
