variable "region" {
  type = string
  default = "ap-southeast-2"
}

variable "project_name" {
  type = string
  description = "Name of the project"
}

variable "inference_instance_type" {
  type = string
  description = "Instance type for the inference"
}

variable "s3_object_inference_data" {
  type = string
  description = "S3 object for the inference data"
}

variable "s3_bucket_output_models_path" {
  type = string
  description = "S3 bucket for the output models"
}

variable "lambda_function_name" {
  type = string
  description = "Name of the lambda function creating a unique ID"
}

variable "handler_path" {
  type = string
  description = "Path of the lambda handler"
}

variable "handler" {
  type = string
  description = "Name of the lambda handler"
}

variable "lambda_folder" {
  type = string
  description = "Folder of the lambda function"
}

variable "lambda_zip_filename" {
  type = string
  description = "Name of the lambda zip file"
}

variable "runtime" {
  type = string
  default = "python3.7"
}

variable "memory_size" {
  type = string
  description = "Memory Lambda in MB"
  default = "128"
}

variable "timeout" {
  type = string
  description = "Timeout Lambda in seconds"
  default = "200"
}

variable "volume_size_sagemaker" {
  type = number
  description = "Volume size for the SageMaker instance in GB"
}

