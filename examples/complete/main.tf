module "ecs" {
  source  = "terraform-volcenginecc-modules/ecs-instance/volcenginecc"
  version = "~> 1.0"

  instances = {
    web_01 = {
      instance_name      = "complete-web-01"
      instance_type      = var.instance_type
      zone_id            = var.zone_id
      image_id           = var.image_id
      subnet_id          = var.subnet_id
      security_group_ids = [var.security_group_id]
      key_pair_name      = var.key_pair_name
      private_ip_address = var.web_private_ip
      user_data          = base64encode("#!/bin/bash\nsystemctl enable nginx")

      system_volume = {
        volume_type = "ESSD_PL0"
        size        = 40
      }

      data_volumes = {
        application = {
          volume_type = "ESSD_FlexPL"
          size        = 100
        }
      }

      tags = {
        Environment = "prod"
        ManagedBy   = "terraform"
        Role        = "web"
      }
    }

    bastion = {
      instance_name      = "complete-bastion-01"
      instance_type      = var.instance_type
      zone_id            = var.zone_id
      image_id           = var.image_id
      subnet_id          = var.subnet_id
      security_group_ids = [var.security_group_id]
      key_pair_name      = var.key_pair_name

      system_volume = {
        volume_type = "ESSD_PL0"
        size        = 40
      }

      eip = {
        bandwidth_mbps        = 5
        charge_type           = "PayByBandwidth"
        release_with_instance = true
      }

      tags = {
        Environment = "prod"
        ManagedBy   = "terraform"
        Role        = "bastion"
      }
    }

    batch_spot = {
      instance_name      = "complete-batch-spot-01"
      instance_type      = var.instance_type
      zone_id            = var.zone_id
      image_id           = var.image_id
      subnet_id          = var.subnet_id
      security_group_ids = [var.security_group_id]
      key_pair_name      = var.key_pair_name
      spot_strategy      = "SpotWithPriceLimit"
      spot_price_limit   = 0.5

      system_volume = {
        volume_type = "ESSD_PL0"
        size        = 40
      }

      tags = {
        Environment = "prod"
        ManagedBy   = "terraform"
        Role        = "batch"
      }
    }

    managed_node = {
      instance_name             = "complete-managed-01"
      instance_type             = var.instance_type
      zone_id                   = var.zone_id
      image_id                  = var.image_id
      subnet_id                 = var.subnet_id
      security_group_ids        = [var.security_group_id]
      key_pair_name             = var.key_pair_name
      role_names                = [var.session_role_name]
      install_run_command_agent = true

      system_volume = {
        volume_type = "ESSD_PL0"
        size        = 40
      }

      tags = {
        Environment = "prod"
        ManagedBy   = "terraform"
        Role        = "session-managed"
      }
    }

    gpu = {
      instance_name      = "complete-gpu-01"
      instance_type      = var.gpu_instance_type
      zone_id            = var.zone_id
      image_id           = var.image_id
      subnet_id          = var.subnet_id
      security_group_ids = [var.security_group_id]
      key_pair_name      = var.key_pair_name
      hpc_cluster_id     = var.hpc_cluster_id

      system_volume = {
        volume_type = "ESSD_PL0"
        size        = 100
      }

      tags = {
        Environment = "prod"
        ManagedBy   = "terraform"
        Role        = "gpu"
      }
    }

    bare_metal = {
      instance_name      = "complete-baremetal-01"
      instance_type      = var.bare_metal_instance_type
      zone_id            = var.zone_id
      image_id           = var.image_id
      subnet_id          = var.subnet_id
      security_group_ids = [var.security_group_id]
      key_pair_name      = var.key_pair_name

      system_volume = {
        volume_type = "ESSD_PL0"
        size        = 100
      }

      tags = {
        Environment = "prod"
        ManagedBy   = "terraform"
        Role        = "bare-metal"
      }
    }
  }
}
