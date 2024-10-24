#Get the caller identity info
data "aws_caller_identity" "current" {}

#call the module
module "inference" {
  source = "../inference-pipeline"
  project_name = var.project_name
  inference_instance_type = var.inference_instance_type
  volume_size_sagemaker = var.volume_size_sagemaker
  s3_object_inference_data = local.s3_object_inference_data
  s3_bucket_output_models_path = local.s3_bucket_output_models_path
  lambda_function_name = local.lambda_function_name
  handler_path = var.handler_path
  handler = var.handler
  lambda_folder = local.lambda_folder
  lambda_zip_filename = local.lambda_zip_filename
}

# Output Elastic Container Registry URL
output "ecr_repository_url" {
  value = module.inference.ecr_repository_url
  description = "ECR url for the Docker Image"
}