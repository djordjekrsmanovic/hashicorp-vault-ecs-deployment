storage "dynamodb" {
  ha_enabled = "true"
  region     = "us-east-1"
  table      = "vault-data"
}


listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}


seal "awskms" {
  region     = "us-east-1"
  kms_key_id = "${kms_key_id}"
}

ui = true
cluster_addr  = "http://127.0.0.1:8201"
api_addr      = "http://127.0.0.1:8205"

