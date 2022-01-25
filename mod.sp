mod "terraform_sherlock" {
  # Hub metadata
  title         = "Terraform Azure Compliance"
  description   = "Run compliance and security controls to detect Terraform Azure resources deviating from security best practices prior to deployment in your Azure subscriptions."
  color         = "#844FBA"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/terraform-azure-compliance.svg"
  categories    = ["azure", "compliance", "iaas", "security", "terraform"]

  opengraph {
    title        = "Steampipe Mod to Analyze Terraform"
    description  = "Run compliance and security controls to detect Terraform Azure resources deviating from security best practices prior to deployment in your Azure subscriptions."
    image        = "/images/mods/turbot/terraform-azure-compliance-social-graphic.png"
  }

  require {
    plugin "terraform" {
      version = "0.0.1"
    }
  }
}
