provider "aws" {
  region = "eu-central-1"
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = "a9dc6eba023e444b9b368dc887d8b5e7-1168339647.eu-central-1.elb.amazonaws.com" # Замените на DNS-имя вашего существующего балансировщика нагрузки
    origin_id = "a9dc6eba023e444b9b368dc887d8b5e7-1168339647.eu-central-1.elb.amazonaws.com"
    custom_origin_config {
        http_port              = 80 // Required to be set but not used
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
  }

  enabled         = true
  is_ipv6_enabled = false
  http_version    = "http2"
  price_class     = "PriceClass_All"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "a9dc6eba023e444b9b368dc887d8b5e7-1168339647.eu-central-1.elb.amazonaws.com"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

data "aws_elb" "my_elb" {
  name = "a9dc6eba023e444b9b368dc887d8b5e7" # Замените на имя вашего существующего Classic Load Balancer
}
