mod "terraform_azure_compliance" {
  # Hub metadata
  title         = "Terraform Azure Compliance"
  description   = "Run compliance and security controls to detect Terraform Azure resources deviating from security best practices prior to deployment in your Azure subscriptions."
  color         = "#844FBA"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/terraform-azure-compliance.svg"
  categories    = ["azure", "compliance", "iac", "security", "terraform"]

  opengraph {
    title        = "Powerpipe Mod to Analyze Terraform"
    description  = "Run compliance and security controls to detect Terraform Azure resources deviating from security best practices prior to deployment in your Azure subscriptions."
    image        = "/images/mods/turbot/terraform-azure-compliance-social-graphic.png"
  }

  require {
    plugin "terraform" {
      min_version = "0.10.0"
    }
  }
}
