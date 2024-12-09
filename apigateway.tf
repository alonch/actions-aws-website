resource "aws_apigatewayv2_api" "main" {
  name          = "static-website-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "s3" {
  api_id             = aws_apigatewayv2_api.main.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = aws_s3_bucket.website.website_endpoint
  integration_method = "GET"
}

resource "aws_apigatewayv2_route" "all" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.s3.id}"
} 