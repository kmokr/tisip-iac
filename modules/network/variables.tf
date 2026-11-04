


variable "name_prefix" {
  description = "Prefiks alle ressursnavn i modulen bygges fra, f.eks. \"krmk404-iac\"."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{3,20}$", var.name_prefix))
    error_message = "name_prefix kan bare inneholde små bokstaver, tall og bindestrek (3–20 tegn)."
  }
}
variable "location" {
  description = "Azure-region for ressursene. Settes av den som kaller modulen"
  type        = string
}
variable "resource_group_name" {
  description = "Navnet på ressursgruppen som eksisterer eller skal opprettes"
  type        = string
}
variable "tags" {
  description = "Tags som skal settes på ressursene"
  type        = map(string)
  default     = {}
}
variable "address_space" {
  description = "CIDR-blokken som skal brukes for det virtuelle nettverket"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}
variable "subnet_address_prefix" {
  description = "CIDR-blokken som skal brukes for subnettet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "ssh_source_prefix" {
  type        = string
  description = "Hvor SSH (port 22) er tillatt fra. Aldri \"*\"."
  default     = "VirtualNetwork"
}
