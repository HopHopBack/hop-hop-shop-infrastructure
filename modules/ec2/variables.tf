# ami-0c35b3c245847df2e
variable "ami_id" {
  description = "The ID of the AMI to use for the EC2 instance"
  type        = string
  default     = "ami-0c35b3c245847df2e"
}

variable "key_name" {
  description = "The key pair name to associate with the instance"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to launch the instance in"
  type        = string
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with the instance"
  type        = list(string)
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to the instance"
  type        = map(string)
  default     = {}
}

variable "root_block_device" {
  description = "Optional configuration for the root block device"
  type = object({
    volume_type           = string
    volume_size           = number
    delete_on_termination = bool
  })
  default = null
}

variable "instances" {
  description = "List of EC2 instances to create"
  type = list(object({
    instance_type = string
    instance_name = string
    volume_size   = number
  }))

  default = [
    {
      instance_type = "t2.micro"
      instance_name = "My ECS t2.micro Instance"
      volume_size   = 5
    },
    {
      instance_type = "t3.medium"
      instance_name = "My ECS t3.medium Instance 1"
      volume_size   = 5
    },
    {
      instance_type = "t3.medium"
      instance_name = "My ECS t3.medium Instance 2"
      volume_size   = 5
    }
  ]
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster to join"
  type        = string
  default     = "hophopecs"
}
