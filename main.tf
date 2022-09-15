resource "aws_iam_role" "this" {
  tags = var.tags
  name = "${var.name}-lambda-role"

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

resource "aws_iam_policy" "xray" {
  tags = var.tags
  name = "${var.name}-xray"
  path = "/service-role/xray-daemon/"
  description = "IAM policy to allow services to write data to X-Ray"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "xray:*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "logs" {
  tags = var.tags  
  name = "${var.name}-cloudwatch"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "logs" {
  role = aws_iam_role.this.name
  policy_arn = aws_iam_policy.logs.arn
}
resource "aws_iam_role_policy_attachment" "xray" {
  role = aws_iam_role.this.name
  policy_arn = aws_iam_policy.xray.arn
}
resource "aws_lambda_function" "this" {
  tags = var.tags  
  filename      = var.filename
  function_name = var.name
  role          = aws_iam_role.this.arn
  handler       = var.handler
  layers        = var.layers 
  timeout       = var.timeout
  memory_size   = var.memory_size

  source_code_hash = var.source_code_hash

  runtime       = var.runtime
  tracing_config {
    mode = "Active"
  }
  dynamic "environment" {
    for_each = var.variables != null ? [var.variables] : []
    content {
      variables = environment.value
    }
  }
  environment {
    variables = var.variables
  }
}