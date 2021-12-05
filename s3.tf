resource "aws_s3_bucket" "bucket_for_csv" {
  bucket = "poco-for-csv"
  acl    = "private"
}

#notification configuration to Lambda Function named 'read_csv_fct'
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket_for_csv.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.read_csv_fct.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_lambda_permission.allow_bucket]
}