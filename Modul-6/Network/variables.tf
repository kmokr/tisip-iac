variable "student_id" {
  description = "Unik student-ID"
  type        = string
}

variable "project" {
  description = "Prosjektnavn for miljøet"
  type        = string
}

variable "location" {
  description = "Azure-region"
  type        = string
  default     = "norwayeast"
}