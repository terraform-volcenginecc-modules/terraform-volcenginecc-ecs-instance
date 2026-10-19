# terraform-volcenginecc-ecs-instance

## 1. Overview

Terraform module for managing Volcengine ECS INSTANCE resources with the `volcenginecc` provider. The caller owns provider authentication, region configuration, and external resources passed by ID.

## 2. Usage

```hcl
module "ecs_instance" {
  source  = "terraform-volcenginecc-modules/ecs-instance/volcenginecc"
  version = "~> 1.0"

  # Set the required module inputs for your environment.
}
```

## 3. Examples

- `basic`: independently runnable basic configuration.
- `complete`: independently runnable complete configuration.

## 4. Requirements

| Name | Version |
|---|---|
| Terraform | `>= 1.5.7` |
| OpenTofu | `>= 1.11.8` |

## 5. Providers

| Name | Source |
|---|---|
| `volcenginecc` | `volcengine/volcenginecc` |

## 6. Resources

| Name | Description |
|---|---|
| `volcenginecc_ecs_instance` | Module-defined volcenginecc_ecs_instance. |

## 7. Inputs

| Name | Description |
|---|---|
| `instances` | Module-defined instances. |

## 8. Outputs

| Name | Description |
|---|---|
| `instances` | Module-defined instances. |
| `instance_ids` | Module-defined instance_ids. |

## 9. Notes

- Configure credentials using supported provider mechanisms; do not put access keys in module files.
- Review replacement behavior and provider constraints before applying changes.
- Run `terraform plan` after apply and confirm that the second plan has no changes.
