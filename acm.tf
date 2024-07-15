resource "tls_private_key" "demo" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "demo" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.demo.private_key_pem

  subject {
    common_name  = "demo.com"
    organization = "Demos, Inc"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "cert" {
  private_key      = tls_private_key.demo.private_key_pem
  certificate_body = tls_self_signed_cert.demo.cert_pem
}