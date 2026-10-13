variable "kortnavn" {
  description = "Ditt unike kortnavn (små bokstaver og tall, 3-8 tegn)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,8}$", var.kortnavn))
    error_message = "kortnavn må være 3-8 tegn, kun små bokstaver og tall."
  }
}

variable "location" {
  type    = string
  default = "norwayeast"
}

variable "pipeline_principal_id" {
  description = "OBJECT-ID til service principal-en, ikke client-ID. Se seksjon 10."
  type        = string
}

locals {
  tags = {
    student = var.kortnavn
    course  = "iac"
    keep    = "true"
  }
}