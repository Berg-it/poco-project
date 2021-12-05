
#Generates an archive from content, a file, or directory of files.
data "archive_file" "lambda-csv" {
  type        = "zip"
  source_file = "${path.module}/lambda/read_csv.py"
  output_path = "${path.module}/lambda/myzip/read.zip"
}

#Generates an archive from content, a file, or directory of files.
data "archive_file" "lambda-presigned" {
  type        = "zip"
  source_file = "${path.module}/lambda/presigned_url.py"
  output_path = "${path.module}/lambda/myzip/presigned.zip"
}

# Create a lambda function
# In terraform ${path.module} is the current directory.
resource "aws_lambda_function" "read_csv_fct" {
  filename         = "${path.module}/lambda/myzip/read.zip"
  function_name    = "read_CSV_files"
  role             = aws_iam_role.lambda_role_read_csv_fct.arn
  handler          = "read_csv.lambda_handler"
  runtime          = "python3.8"
  depends_on       = [aws_iam_role_policy_attachment.policy_attach]
  source_code_hash = data.archive_file.lambda-csv.output_base64sha256
}

resource "aws_lambda_function" "get_persgned_url" {
  filename         = "${path.module}/lambda/myzip/presigned.zip"
  function_name    = "get_persgned_url"
  role             = aws_iam_role.lambda_presigned_url_fct.arn
  handler          = "presigned_url.lambda_handler"
  runtime          = "python3.8"
  depends_on       = [aws_iam_role_policy_attachment.policy_attach]
  source_code_hash = data.archive_file.lambda-presigned.output_base64sha256

  environment {
    variables = {
      bucket_name = "${aws_s3_bucket_notification.bucket_notification.id}"
    }
  }

}


output "lambda_role_read_csv_fct_role_name" {
  value = aws_iam_role.lambda_role_read_csv_fct.name
}

output "lambda_role_read_csv_fct_role_arn" {
  value = aws_iam_role.lambda_role_read_csv_fct.arn
}