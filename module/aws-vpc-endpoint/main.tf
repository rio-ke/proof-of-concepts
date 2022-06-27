# aws_vpc_endpoint.GWM-PRIVATE-NEWENDPOINT:
resource "aws_vpc_endpoint" "ave" {
    cidr_blocks           = []
    ip_address_type       = "ipv4"
    network_interface_ids = [
        "eni-03e39d081a6ad7f12",
        "eni-0673a03f5f6f1a772",
    ]
    policy                = jsonencode(
        {
            Statement = [
                {
                    Action    = "*"
                    Effect    = "Allow"
                    Principal = "*"
                    Resource  = "*"
                },
            ]
        }
    )
    private_dns_enabled   = true
    requester_managed     = false
    route_table_ids       = []
    security_group_ids    = [
        "sg-02ebf76fd113ae4d4",
    ]
    service_name          = "com.amazonaws.ap-southeast-1.execute-api"
    subnet_ids            = [
        "subnet-076a9ab7a5daf4395",
        "subnet-0c8b13170675b9431",
    ]
    tags                  = {
        "Name" = "GWM-PRIVATE-NEWENDPOINT"
    }

    vpc_endpoint_type     = "Interface"
    vpc_id                = "vpc-04fc3b6b0abc327a9"

    dns_options {
        dns_record_ip_type = "ipv4"
    }

}