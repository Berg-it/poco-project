resource "aws_iam_role" "lambda_role_read_csv_fct" {
  name               = "iam_role_lambda_function"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
    "Action": "sts:AssumeRole",
    "Principal": {
        "Service": "lambda.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
    }
]
}
EOF
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
  role       = aws_iam_role.lambda_role_read_csv_fct.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role" "lambda_presigned_url_fct" {
  name               = "presigned-lambda-role"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
    "Action": "sts:AssumeRole",
    "Principal": {
        "Service": "lambda.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
    }
]
}
EOF
}
resource "aws_iam_role_policy_attachment" "policy_attach_presigned" {
  role       = aws_iam_role.lambda_presigned_url_fct.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_iam_policy" "s3_policy" {
  name = "s3-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.bucket_for_csv.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_s3" {
  role       = aws_iam_role.lambda_presigned_url_fct.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

#grant s3 notif lambda when new object is created
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.read_csv_fct.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket_for_csv.arn
}

#grant api-gateway to invoke lambda presigned_url
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_persgned_url.arn
  principal     = "apigateway.amazonaws.com"
  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.customer_api.execution_arn}/*/*/*"
}