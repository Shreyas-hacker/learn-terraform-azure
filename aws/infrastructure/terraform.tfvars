#project name
project_name = "aws-inference-terraform"
region = "ap-southeast-1"

# inference instance and volume
inference_instance_type = "ml.g4dn.xlarge"
volume_size_sagemaker = 5


# lambda function
handler_path = "../../src/lambda_function"
handler = "config_lambda.lambda_handler"