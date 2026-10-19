# BASIC ECS INSTANCE 示例

## 1. 概述

ECS INSTANCE 模块的可运行 basic 配置。它从输入变量设置 Provider，并调用已发布的 Registry 模块。

## 2. 用法

```shell
terraform init
terraform plan
terraform apply
terraform plan
terraform destroy
```

## 3. 示例

本目录即为 basic 示例。

## 4. 版本要求

| 名称 | 版本 |
|---|---|
| Terraform | `>= 1.5.7` |
| OpenTofu | `>= 1.11.8` |

## 5. Provider

| 名称 | 来源 |
|---|---|
| `volcenginecc` | `volcengine/volcenginecc` |

## 6. 资源

| 名称 | 说明 |
|---|---|
| `terraform-volcenginecc-modules/ecs-instance/volcenginecc` | 已发布的 ECS INSTANCE 模块。 |

## 7. 输入

| 名称 | 说明 |
|---|---|
| `zone_id` | 模块定义的 zone_id。 |
| `image_id` | 模块定义的 image_id。 |
| `instance_type` | 模块定义的 instance_type。 |
| `subnet_id` | 模块定义的 subnet_id。 |
| `security_group_id` | 模块定义的 security_group_id。 |
| `key_pair_name` | 模块定义的 key_pair_name。 |

## 8. 输出

| 名称 | 说明 |
|---|---|
| `instance_ids` | 模块定义的 instance_ids。 |

## 9. 注意事项

- 请通过 Provider 支持的配置提供凭据，绝不应写入源文件。
- apply 后的最终 plan 必须报告无变更，才能接受该配置。
