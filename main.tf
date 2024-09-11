# AWS Provider 
provider "aws" {
  region = "us-east-1"
}

# Security Group 
resource "aws_security_group" "tf_sg" {
  name        = "nome do grupo de segurança"
  description = "descrição_do_grupo_de_segurança"

# Gerando Key
resource "aws_key_pair" "key_name" {
  key_name   = "nome_chave"
  public_key = file("caminho_para_a_chave")
}

  # Ingress Rules
  ingress {
    description      = "Prometheus"
    from_port        = 9090
    to_port          = 9090
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Grafana"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Prometheus Node Exporter"
    from_port        = 9100
    to_port          = 9100
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  # Egress Rule
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "TF_SG"
  }
}

# EC2 para Prometheus e Grafana
resource "aws_instance" "instance_name" {
  ami             = "ami-0e86e20dae9224db8"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.tf_sg.name]
  key_name         = "key_name"

  tags = {
    Name = "prometheus_grafana"
  }

  # Arquvio de instalação do prometheus/grafana
  user_data = filebase64("caminho_para_o_arquivo_sh")
}
