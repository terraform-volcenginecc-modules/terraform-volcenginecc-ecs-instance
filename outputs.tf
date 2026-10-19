output "instances" {
  description = "Managed instance details keyed by the input instances map key."
  value = {
    for key, instance in volcenginecc_ecs_instance.this : key => {
      id                           = instance.id
      instance_id                  = instance.instance_id
      instance_name                = instance.instance_name
      private_ip_address           = instance.primary_network_interface.primary_ip_address
      primary_network_interface_id = instance.primary_network_interface.network_interface_id
      eip_address                  = try(instance.eip_address.ip_address, null)
      eip_allocation_id            = try(instance.eip_address.allocation_id, null)
      system_volume_id             = instance.system_volume.volume_id
      data_volume_ids              = [for volume in coalesce(instance.data_volumes, []) : volume.volume_id]
    }
  }
}

output "instance_ids" {
  description = "Managed ECS instance IDs keyed by the input instances map key."
  value       = { for key, instance in volcenginecc_ecs_instance.this : key => instance.instance_id }
}
