# BASIC ECS INSTANCE Example

## 1. Overview

Runnable basic configuration for the ECS INSTANCE module. It configures the provider from input variables and calls the published Registry module.

## 2. Usage

```shell
terraform init
terraform plan
terraform apply
terraform plan
terraform destroy
```

## 3. Examples

This directory is the basic example.

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
| `terraform-volcenginecc-modules/ecs-instance/volcenginecc` | Published ECS INSTANCE module. |

## 7. Inputs

| Name | Description |
|---|---|
| `zone_id` | Module-defined zone_id. |
| `image_id` | Module-defined image_id. |
| `instance_type` | Module-defined instance_type. |
| `subnet_id` | Module-defined subnet_id. |
| `security_group_id` | Module-defined security_group_id. |
| `key_pair_name` | Module-defined key_pair_name. |

## 8. Outputs

| Name | Description |
|---|---|
| `instance_ids` | Module-defined instance_ids. |

## 9. Notes

- Supply credentials through supported provider configuration, never in source files.
- The final plan after apply must report no changes before the configuration is accepted.
