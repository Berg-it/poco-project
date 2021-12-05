resource "aws_api_gateway_rest_api" "customer_api" {
  name = "custom-api"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "basic_resource" {
  rest_api_id = aws_api_gateway_rest_api.customer_api.id
  parent_id   = aws_api_gateway_rest_api.customer_api.root_resource_id
  path_part   = "upload"
}

resource "aws_api_gateway_method" "lambda_method" {
  rest_api_id      = aws_api_gateway_rest_api.customer_api.id
  resource_id      = aws_api_gateway_resource.basic_resource.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.customer_api.id
  resource_id = aws_api_gateway_method.lambda_method.resource_id
  http_method = aws_api_gateway_method.lambda_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_persgned_url.invoke_arn
}


#Since the API Gateway usage plans feature was launched on August 11, 
#2016, usage plans are now required to associate an API key with an API stage
resource "aws_api_gateway_usage_plan" "myusageplan" {
  name = "my_usage_plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.customer_api.id
    stage  = aws_api_gateway_deployment.deployment-stage.stage_name
  }
}
resource "aws_api_gateway_api_key" "mykey" {
  name = "my_key"
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.mykey.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.myusageplan.id
}

resource "aws_api_gateway_deployment" "deployment-stage" {
  rest_api_id = aws_api_gateway_rest_api.customer_api.id
  stage_name  = "test"
}