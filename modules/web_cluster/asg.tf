#Gathers the info for the AMI that is used for the nodes in the ASG
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-2*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "web_launch_config" {
  depends_on                  = [var.web_ssh_key]
  name_prefix                 = "web-lc-"
  image_id                    = data.aws_ami.ubuntu.id
  instance_type               = "t2.medium"
  key_name                    = var.web_ssh_key
  security_groups             = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.web_instance_profile.id
  lifecycle {
    create_before_destroy = true
  }
  root_block_device {
    volume_type = "standard"
    volume_size = 20
  }
  #user_data = data.template_file.scripts.rendered  #Further configurations could be done here or through a preconfigured AMI created by Packer
}


resource "aws_autoscaling_group" "web_main_asg" {
  depends_on           = [aws_launch_configuration.web_launch_config, var.vpc_id]
  name                 = "web-asg"
  vpc_zone_identifier  = [var.public_subnets[0]]
  target_group_arns    = [aws_lb_target_group.LB_Forward_TG_443.arn]
  launch_configuration = aws_launch_configuration.web_launch_config.name
  max_size             = "3"
  min_size             = "1"
  desired_capacity     = "1"
  health_check_type    = "EC2"
}
