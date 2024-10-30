variable "ecr_name" {
  description = "The name of the ECR repository"
  type = string
  default = "mnist-model"
}

variable "image_mutability" {
  description = "provide image mutability"
  type = string
  default = "IMMUTABLE"
}

variable "encrypt_type" {
  description = "type of encryption"
  type = string
  default = "KMS"
}

variable "tags" {
  description = "key-value mapping for tagging"
  type = map(string)
  default = {}
}