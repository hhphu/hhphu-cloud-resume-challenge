variable "domain_name" {
  type        = string
  description = "Name of the domain"
  default     = "hhphu.click"
}


resource "aws_s3_bucket" "hhphu-click" {
  bucket = var.domain_name

}

resource "aws_s3_bucket" "www-hhphu-click" {
  bucket     = "www.${var.domain_name}"
  depends_on = [aws_s3_bucket.hhphu-click]
}

/*
Configure public access ACLs and policies

- block_public_acls: When set to true, this blocks new public ACLs (access control lists) and removes existing public ACLs. Otherwise, it does not block public ACLs.
- block_public_policy: When set to true, this prevents the application of any new or existing public bucket policies. Otherwise, it does not block public bucket policies.
- ignore_public_acls: When set to true, this ignores public ACLs, meaning that public access granted through ACLs will be ignored and not applied. Otherwise, it does not ignore public ACLs.
- restrict_public_buckets: When set to true, this restricts access to the bucket to only AWS services and authorized users within the AWS account, regardless of the specified bucket policies. Otherwise, it does not restrict public buckets.

*/

resource "aws_s3_bucket_public_access_block" "hhphu-click" {
  bucket = aws_s3_bucket.hhphu-click.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_public_access_block" "www-hhphu-click" {
  bucket = aws_s3_bucket.www-hhphu-click.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Upload content of the website onto the main bucket
resource "null_resource" "upload_files" {
  depends_on = [aws_s3_bucket.hhphu-click]
  provisioner "local-exec" {
    command = <<EOF
        aws s3 cp --recursive /home/hhphu/Desktop/cloud-resume-challenge/build s3://${aws_s3_bucket.hhphu-click.bucket}/ --profile terraform-user
        EOF
  }
}



# Create Lambda function
data "archive_file" "zippedLambda" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/"
  output_path = "${path.module}/zippedLambda.zip"
}

# Create Lambda Function URL
resource "aws_lambda_function_url" "lambda_url" {
  function_name      = aws_lambda_function.hhphu-click-views.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

# IAM rule for Lambda to access DynamoDB
resource "aws_lambda_function" "hhphu-click-views" {
  filename         = data.archive_file.zippedLambda.output_path
  source_code_hash = data.archive_file.zippedLambda.output_base64sha256
  function_name    = "hhphu-click-views"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "func.handler"
  runtime          = "python3.10"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

# IAM for Lambda to access the DynamoDB
resource "aws_iam_policy" "iam_policy_for_cloud_resume" {
  name        = "aws_iam_policy_for_cloud_resume_policy"
  path        = "/"
  description = "AWS IAM Policy for managing the cloud resume role"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : "arn:aws:logs:*:*:*",
          "Effect" : "Allow"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:UpdateItem",
            "dynamodb:GetItem"
          ],
          "Resource" : "arn:aws:dynamodb:*:*:table/hhphu.click-count"
        },
      ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.iam_policy_for_cloud_resume.arn
}
