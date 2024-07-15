resource "aws_network_interface" "web-interface" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["172.16.0.5"]
  security_groups = [aws_security_group.allow_web.id]

}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-interface.id
  associate_with_private_ip = "172.16.0.5"
  depends_on                = [aws_internet_gateway.gw]

}

resource "aws_instance" "web" {
  ami               = "ami-0c6615d1e95c98aca"
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1b"
  key_name          = "test-instance"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web-interface.id
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install docker git -y
    sudo service docker start
    sudo git clone https://github.com/rearc/quest /opt/quest/
    
    sudo bash -c 'cat > /opt/quest/Dockerfile << EOF
    FROM node:10
    WORKDIR /usr/src/app
    COPY package*.json ./
    RUN npm install
    COPY . .
    ENV SECRET_WORD=TwelveFactor
    CMD [ "node", "src/000.js" ]
    EOF'

    sudo bash -c 'cat > /opt/quest/.dockerignore << EOF
    node_modules
    npm-debug.log
    EOF'
    
    sudo docker build /opt/quest/  -t  node-web-app
    sudo docker run -p 80:3000 -d node-web-app

    EOF

  tags = {
    Name = "demo-server"
    Env  = "Test"
  }

}
