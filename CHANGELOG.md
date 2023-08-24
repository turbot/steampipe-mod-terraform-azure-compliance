## v0.7 [2023-08-24]

_What's new?_

- Added 118 new controls across the benchmarks for the following services: ([#32](https://github.com/turbot/steampipe-mod-terraform-azure-compliance/pull/32))
  - `API Management`
  - `App Configuration`
  - `Application Gateway`
  - `App Service`
  - `Content Delivery Network`
  - `Cognitive Search`
  - `Compute`
  - `Container Instance`
  - `Container Registry`
  - `Cosmos DB`
  - `Databricks`
  - `Data Explorer`
  - `Data Factory`
  - `Event Grid`
  - `Firewall`
  - `Healthcare APIs`
  - `IAM`
  - `IoT Hub`
  - `Key Vault`
  - `Kubernetes Service`
  - `Machine Learning`
  - `Maria DB`
  - `Monitor`
  - `MySQL`
  - `Network`
  - `PostgreSQL`
  - `Redis`
  - `Security Center`
  - `Service Bus`
  - `SignalR`
  - `Spring Cloud`
  - `SQL`
  - `Storage`
  - `Synapse Analytics`
  - `Web PubSub`

## v0.6 [2023-06-15]

_What's new?_

- Added `connection_name` in the common dimensions to group and filter findings. (see [var.common_dimensions](https://hub.steampipe.io/mods/turbot/terraform_azure_compliance/variables)) ([#23](https://github.com/turbot/steampipe-mod-terraform-azure-compliance/pull/23))
- Added `tags` as dimensions to group and filter findings. (see [var.tag_dimensions](https://hub.steampipe.io/mods/turbot/terraform_azure_compliance/variables)) ([#23](https://github.com/turbot/steampipe-mod-terraform-azure-compliance/pull/23))

## v0.5 [2022-05-09]

_Enhancements_

- Updated docs/index.md and README with new dashboard screenshots and latest format. ([#18](https://github.com/turbot/steampipe-mod-terraform-azure-compliance/pull/18))

## v0.4 [2022-05-02]

_Enhancements_

- Added `category`, `service`, and `type` tags to benchmarks and controls. ([#14](https://github.com/turbot/steampipe-mod-terraform-azure-compliance/pull/14))

## v0.3 [2022-03-17]

_Enhancements_

- Paths in control outputs now also include the starting line number for the resource

## v0.2 [2022-02-10]

_Enhancements_

- Updated `README.md` and `docs/index.md` with more detailed usage instructions

## v0.1 [2022-02-02]

_What's new?_

- Added 34 benchmarks and 151 controls to check Terraform Azure resources against security best practices. Controls for the following services have been added:
  - API Management
  - App Service
  - Batch
  - Cache for Redis
  - Cognitive Search
  - Cognitive Service
  - Compute
  - Container Registry
  - Cosmos DB
  - Data Explorer
  - Data Factory
  - Data lake Store
  - DNS
  - Event Hubs
  - File Sync
  - Front Door
  - Healthcare APIs
  - IoT Hub
  - Key Vault
  - Kubernetes Service
  - Logic Apps
  - Machine Learning
  - MariaDB
  - Monitor
  - MySQL
  - PostgreSQL
  - Resource Manager
  - Security Center
  - Service Fabric
  - Spring Cloud
  - SQL
  - Storage
  - Synapse
  - Virtual Network
