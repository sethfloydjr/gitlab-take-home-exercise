resource "aws_key_pair" "web_ssh_key" {
  key_name   = "gitlab-take-home"
  public_key = "ssh-rsa ------not secure to store this here...should be in Vault or some other secret store ------ "
}
