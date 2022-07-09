# aws_cloudfront_distribution.s3_distribution:
resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled          = true
  http_version     = "http2"
  is_ipv6_enabled  = true
  price_class      = "PriceClass_All"
  retain_on_delete = false
  tags             = var.tags
  
  #   trusted_key_groups = [
  #     {
  #       enabled = false
  #       items   = []
  #     },
  #   ]
  #   trusted_signers = [
  #     {
  #       enabled = false
  #       items   = []
  #     },
  #   ]

  custom_error_response {
    error_caching_min_ttl = 1
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = aws_s3_bucket.bucket.bucket_regional_domain_name
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id           = aws_s3_bucket.bucket.bucket_regional_domain_name

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/E2FRCTUOYI9N4S"
    }
  }
  restrictions {
    geo_restriction {
      locations = [
        "AS",
        "GU",
        "MP",
        "PR",
        "US",
        "VI",
      ]
      restriction_type = "whitelist"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1"
  }
}


