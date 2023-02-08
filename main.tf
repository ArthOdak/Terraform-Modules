/*
resource "aws_iam_role" "oc" {
  name = "example"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Sid    = "",
        Principal = {
          Service =[
             "ec2.amazonaws.com"
            ]
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "chaand" {
  name = "chaand"
  role = aws_iam_role.oc.name
}

resource "aws_iam_role_policy" "rule" {
  name = "rule"
  role = aws_iam_role.oc.name
  policy = jsonencode({
  Statement = [{
      Action = "s3:*",
      Effect = "Allow",
      Resource = "*"
    }],
    
  })
}
*/
resource "aws_vpc" "main1" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main1.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  #enable_dns64 = true
  tags = {
    Name = "Main"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main1.id

  tags = {
    Name = "main"
  }
}

resource "aws_security_group" "sec1" {
  name        = "sec-grp"
  description = "sec-grp"
  vpc_id      = aws_vpc.main1.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sec-grp"
  }
}

resource "aws_instance" "bigboss" {
  #count           = var.environment == "prod" ? 1 : 0
  #for_each      = aws_subnet.main.id
  ami             = "ami-0aa7d40eeae50c9a9"
  instance_type   = "t2.micro"
  subnet_id        = "${aws_subnet.main.id}"
  #security_groups = [aws_security_group.sec.name]
  vpc_security_group_ids = ["${aws_security_group.sec1.id}"]
  //iam_instance_profile = aws_iam_instance_profile.chaand.name
  /*
  depends_on = [
    aws_iam_role_policy.rule
  ]
  */
  tags = {
    name = "ec2 "//${count.index}"
  }
}

