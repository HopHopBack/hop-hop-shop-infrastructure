source "amazon-ebs" "ubuntu-ecs" {
  ami_name      = "ubuntu-ecs-optimized"
  instance_type = "t2.micro"
  region        = "eu-central-1"
  ssh_username  = "ubuntu"

  source_ami_filter {
    owners      = ["099720109477"] # Ubuntu owner ID
    most_recent = true
    filters = {
      name   = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
  }
}

build {
  name = "ubuntu-ecs-docker"

  sources = ["source.amazon-ebs.ubuntu-ecs"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get -y install ca-certificates curl gnupg lsb-release",
      "sudo mkdir -p /etc/apt/keyrings",
      "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "sudo usermod -aG docker ubuntu",
      "newgrp docker",
      "sudo curl -O https://s3.us-east-1.amazonaws.com/amazon-ecs-agent-us-east-1/amazon-ecs-init-latest.amd64.deb",
      "sudo dpkg -i amazon-ecs-init-latest.amd64.deb",
      "sudo systemctl start ecs"
    ]
  }
}
