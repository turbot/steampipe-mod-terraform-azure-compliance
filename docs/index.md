---
repository: "https://github.com/turbot/steampipe-mod-terraform-azure-compliance"
---

# Terraform Azure Compliance

Run compliance and security controls to detect Terraform Azure resources deviating from security best practices prior to deployment in your Azure subscriptions.

![image](https://raw.githubusercontent.com/turbot/steampipe-mod-terraform-azure-compliance/main/docs/terraform_azure_compliance_console_output.png)

## References

[Terraform](https://terraform.io/) is an open-source infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services.

[Steampipe](https://steampipe.io) is an open source CLI to instantly query cloud APIs using SQL.

[Steampipe Mods](https://steampipe.io/docs/reference/mod-resources#mod) are collections of `named queries`, and codified `controls` that can be used to test current configuration of your cloud resources against a desired configuration.


## Documentation

- **[Benchmarks and controls →](https://hub.steampipe.io/mods/turbot/terraform_azure_compliance/controls)**
- **[Named queries →](https://hub.steampipe.io/mods/turbot/terraform_azure_compliance/queries)**

## Get started

Install the Terraform plugin with [Steampipe](https://steampipe.io):

```shell
steampipe plugin install terraform
```

Configure the Terraform plugin, adding any path that contains your Terraform files to `paths`:

```sh
vi ~/.steampipe/config/terraform.spc
```

```hcl
connection "terraform" {
  plugin = "terraform"
  paths  = ["/path/to/my/tf/files/*.tf"]
}
```

For more details on connection configuration, please refer [Terraform Plugin Configuration](https://hub.steampipe.io/plugins/turbot/terraform#configuration).

Clone:

```sh
git clone https://github.com/turbot/steampipe-mod-terraform-azure-compliance.git
cd steampipe-mod-terraform-azure-compliance
```

Run all benchmarks:

```shell
steampipe check all
```

Run all benchmarks for a specific compliance framework using tags:

```shell
steampipe check all --tag hipaa_hitrust_v92=true
```

Run a benchmark:

```shell
steampipe check terraform_azure_compliance.benchmark.storage
```

Run a specific control:

```shell
steampipe check terraform_azure_compliance.control.storage_account_infrastructure_encryption_enabled
```

### Credentials

This mod uses the credentials configured in the [Steampipe Terraform plugin](https://hub.steampipe.io/plugins/turbot/terraform).

### Configuration

No extra configuration is required.

## Get involved

* Contribute: [GitHub Repo](https://github.com/turbot/steampipe-mod-terraform-azure-compliance)
* Community: [Slack Channel](https://steampipe.io/community/join)
