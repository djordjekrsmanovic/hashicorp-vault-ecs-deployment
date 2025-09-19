resource "aws_dynamodb_table" "dynamodb-table" {
  name           = "${var.name}"
  billing_mode    = "PAY_PER_REQUEST"
  hash_key       = "Path"
  range_key      = "Key"

  attribute {
    name = "Path"
    type = "S"
  }

  attribute {
    name = "Key"
    type = "S"
  }

  tags = {
    Name        = "vault-dynamodb-table"
    Environment = "prod"
  }
}