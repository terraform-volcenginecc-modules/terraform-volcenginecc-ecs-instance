module "ecs" {
  source  = "terraform-volcenginecc-modules/ecs-instance/volcenginecc"
  version = "~> 1.0"

  instances = {
    web = {
      instance_name      = "basic-web-01"
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

      tags = {
        Environment = "dev"
        ManagedBy   = "terraform"
        Role        = "web"
      }
    }
  }
}
