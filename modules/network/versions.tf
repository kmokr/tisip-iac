terraform {
  required_version = ">= 1.7.0" # mock_provider i testene krever 1.7

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.4" # samme hovedversjon som rotmodulene
    }
  }
}