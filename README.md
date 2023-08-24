# Terraform Azure Compliance Mod for Steampipe

150+ compliance and security controls to test your Terraform Azure resources against security best practices prior to deployment in your Azure subscriptions.

Run checks in a dashboard:

![image](https://raw.githubusercontent.com/turbot/steampipe-mod-terraform-azure-compliance/main/docs/terraform_azure_compliance_dashboard.png)

Or in a terminal:

![image](https://raw.githubusercontent.com/turbot/steampipe-mod-terraform-azure-compliance/main/docs/terraform_azure_compliance_console_output.png)

## Getting started

### Installation

Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install steampipe
```

Install the terraform plugin with [Steampipe](https://steampipe.io):

```sh
steampipe plugin install terraform
```

Clone:

```sh
git clone https://github.com/turbot/steampipe-mod-terraform-azure-compliance.git
```

### Usage

By default, the Terraform plugin configuration loads Terraform configuration
files in your current working directory (CWD).

To get started, change your CWD to where your TF files are located:

```sh
cd /path/to/tf_files
```

Then set the `STEAMPIPE_WORKSPACE_CHDIR` environment variable to the mod directory so Steampipe knows where to load benchmarks from:

```sh
export STEAMPIPE_WORKSPACE_CHDIR=/path/to/steampipe-mod-terraform-azure-compliance
```

Start your dashboard server:

```sh
steampipe dashboard
```

By default, the dashboard interface will then be launched in a new browser
window at http://localhost:9194. From here, you can run benchmarks by
selecting one or searching for a specific one.

Instead of running benchmarks in a dashboard, you can also run them within your
terminal with the `steampipe check` command.

Run all benchmarks:

```sh
steampipe check all
```

Run all benchmarks for a specific compliance framework using tags:

```sh
steampipe check all --tag cft_scorecard_v1=true
```

Run a benchmark:

```sh
steampipe check terraform_azure_compliance.benchmark.storage
```

Run a specific control:

```sh
steampipe check terraform_azure_compliance.control.storage_account_infrastructure_encryption_enabled
```

When running checks from the CWD, you can also run the `steampipe dashboard` and `steampipe check` commands using the `--workspace-chdir` command line argument:

```sh
steampipe dashboard --workspace-chdir=/path/to/steampipe-mod-terraform-azure-compliance
steampipe check all --workspace-chdir=/path/to/steampipe-mod-terraform-azure-compliance
```

Different output formats are also available, for more information please see
[Output Formats](https://steampipe.io/docs/reference/cli/check#output-formats).

### Credentials

No credentials are required.

### Configuration

If you want to run benchmarks and controls across multiple directories
containing Terraform configuration files, they can be run from within the
`steampipe-mod-terraform-azure-compliance` mod directory after configuring the
Terraform plugin configuration:

```sh
vi ~/.steampipe/config/terraform.spc
```

```hcl
connection "terraform" {
  plugin = "terraform"
  paths  = ["/path/to/files/*.tf", "/path/to/nested/files/**/*.tf"]
}
```

After setting up your Terraform plugin configuration, navigate to the `steampipe-mod-terraform-azure-compliance` mod directory and start the dashboard server:

```sh
cd /path/to/steampipe-mod-terraform-azure-compliance
steampipe dashboard
```

For more details on connection configuration, please refer to [Terraform Plugin Configuration](https://hub.steampipe.io/plugins/turbot/terraform#configuration).

### Common and Tag Dimensions

The benchmark queries use common properties (like `connection_name` and `path`) and tags that are defined in the form of a default list of strings in the `mod.sp` file. These properties can be overwritten in several ways:

- Copy and rename the `steampipe.spvars.example` file to `steampipe.spvars`, and then modify the variable values inside that file
- Pass in a value on the command line:

  ```shell
  steampipe check benchmark.compute --var 'common_dimensions=["connection_name", "path"]'
  ```

  ```shell
  steampipe check benchmark.compute --var 'tag_dimensions=["Environment", "Owner"]'
  ```

- Set an environment variable:

  ```shell
  SP_VAR_common_dimensions='["connection_name", "path"]' steampipe check control.compute_vm_azure_defender_enabled
  ```

  ```shell
  SP_VAR_tag_dimensions='["Environment", "Owner"]' steampipe check control.compute_vm_azure_defender_enabled
  ```

## Contributing

If you have an idea for additional controls or just want to help maintain and extend this mod ([or others](https://github.com/topics/steampipe-mod)) we would love you to join the community and start contributing.

- **[Join #steampipe on Slack →](https://turbot.com/community/join)** and hang out with other Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-terraform-azure-compliance/blob/main/LICENSE).

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [Terraform Azure Compliance Mod](https://github.com/turbot/steampipe-mod-terraform-azure-compliance/labels/help%20wanted)
