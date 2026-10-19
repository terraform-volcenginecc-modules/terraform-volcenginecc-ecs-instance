resource "volcenginecc_ecs_instance" "this" {
  for_each = var.instances

  instance_name             = each.value.instance_name
  instance_type             = each.value.instance_type
  zone_id                   = each.value.zone_id
  project_name              = each.value.project_name
  description               = each.value.description
  hostname                  = each.value.hostname
  instance_charge_type      = each.value.instance_charge_type
  period                    = each.value.period
  period_unit               = each.value.period_unit
  auto_pay                  = each.value.auto_pay
  auto_renew                = each.value.auto_renew
  auto_renew_period         = each.value.auto_renew_period
  spot_strategy             = each.value.spot_strategy
  spot_price_limit          = each.value.spot_price_limit
  role_names                = length(each.value.role_names) == 0 ? null : each.value.role_names
  user_data                 = each.value.user_data
  install_run_command_agent = each.value.install_run_command_agent
  hpc_cluster_id            = each.value.hpc_cluster_id

  image = merge(
    { image_id = each.value.image_id },
    each.value.image_release_version == null ? {} : { image_release_version = each.value.image_release_version },
    each.value.keep_image_credential == null ? {} : { keep_image_credential = each.value.keep_image_credential },
    each.value.security_enhancement_strategy == null ? {} : { security_enhancement_strategy = each.value.security_enhancement_strategy },
  )

  primary_network_interface = merge(
    {
      subnet_id          = each.value.subnet_id
      security_group_ids = each.value.security_group_ids
    },
    each.value.private_ip_address == null ? {} : { primary_ip_address = each.value.private_ip_address },
    each.value.private_ip_addresses == null ? {} : { private_ip_addresses = each.value.private_ip_addresses },
    each.value.ipv_6_address_count == null ? {} : { ipv_6_address_count = each.value.ipv_6_address_count },
  )

  system_volume = merge(
    {
      volume_type          = each.value.system_volume.volume_type
      size                 = each.value.system_volume.size
      delete_with_instance = each.value.system_volume.delete_with_instance
    },
    each.value.system_volume.snapshot_id == null ? {} : { snapshot_id = each.value.system_volume.snapshot_id },
    each.value.system_volume.extra_performance_type_id == null ? {} : { extra_performance_type_id = each.value.system_volume.extra_performance_type_id },
    each.value.system_volume.extra_performance_iops == null ? {} : { extra_performance_iops = each.value.system_volume.extra_performance_iops },
    each.value.system_volume.extra_performance_throughput_mb == null ? {} : { extra_performance_throughput_mb = each.value.system_volume.extra_performance_throughput_mb },
  )

  data_volumes = length(each.value.data_volumes) == 0 ? null : [
    for volume in values(each.value.data_volumes) : merge(
      {
        volume_type          = volume.volume_type
        size                 = volume.size
        delete_with_instance = volume.delete_with_instance
      },
      volume.snapshot_id == null ? {} : { snapshot_id = volume.snapshot_id },
      volume.extra_performance_type_id == null ? {} : { extra_performance_type_id = volume.extra_performance_type_id },
      volume.extra_performance_iops == null ? {} : { extra_performance_iops = volume.extra_performance_iops },
      volume.extra_performance_throughput_mb == null ? {} : { extra_performance_throughput_mb = volume.extra_performance_throughput_mb },
    )
  ]

  key_pair = each.value.key_pair_name == null ? null : {
    key_pair_name = each.value.key_pair_name
  }

  eip_address = each.value.eip == null ? null : merge(
    { release_with_instance = each.value.eip.release_with_instance },
    each.value.eip.bandwidth_mbps == null ? {} : { bandwidth_mbps = each.value.eip.bandwidth_mbps },
    each.value.eip.bandwidth_package_id == null ? {} : { bandwidth_package_id = each.value.eip.bandwidth_package_id },
    each.value.eip.charge_type == null ? {} : { charge_type = each.value.eip.charge_type },
    each.value.eip.isp == null ? {} : { isp = each.value.eip.isp },
    each.value.eip.security_protection_types == null ? {} : { security_protection_types = each.value.eip.security_protection_types },
  )

  tags = [
    for tag_key, tag_value in each.value.tags : {
      key   = tag_key
      value = tag_value
    }
  ]

  # The Registry provider returns these unset Optional+Computed fields as unknown.
  lifecycle {
    ignore_changes = [
      image.image_release_version,
      image.keep_image_credential,
      image.security_enhancement_strategy,
      primary_network_interface.private_ip_addresses,
      role_names,
      system_volume.extra_performance_iops,
      system_volume.extra_performance_throughput_mb,
      system_volume.extra_performance_type_id,
      system_volume.snapshot_id,
    ]
  }
}
