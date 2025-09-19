data "aws_caller_identity" "current" {}

# 1️⃣ Create KMS Key
resource "aws_kms_key" "encryption" {
  description         = "KMS key for ECS tasks"
  enable_key_rotation = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "Allow administration of the key"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}

# 2️⃣ Create KMS alias
resource "aws_kms_alias" "encryption" {
  name          = "alias/my-app-key"
  target_key_id = aws_kms_key.encryption.key_id
}

output "encryption" {
  value = aws_kms_key.encryption
}