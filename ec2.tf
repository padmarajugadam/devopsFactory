provider "aws" {
  region  = "us-west-2"
}

resource "aws_instance" "k8s_master" {
  ami           = "ami-074be47313f84fa38"
  instance_type = "t2.medium"
  associate_public_ip_address = "true"
  subnet_id = aws_subnet.publicsubnetstf.id
  vpc_security_group_ids = [ aws_security_group.vpc_security_tf.id, ]
  key_name = "test"
  tags = {
    Name = "kubernetes-master"
  }
}

resource "aws_instance" "k8s_node" {
  count         = 2
  ami           = "ami-074be47313f84fa38"
  instance_type = "t2.medium"
  associate_public_ip_address = "true"
  subnet_id = aws_subnet.publicsubnetstf.id 
  vpc_security_group_ids = [ aws_security_group.vpc_security_tf.id, ]
  key_name = var.key_name
  depends_on    = [ aws_instance.k8s_master ]
  tags = {
    Name = "kubernetes-node-${count.index}"
  }
}
resource "local_file" "ansible_inventory" {
  content = <<EOF
[kubernetes-master]
${aws_instance.k8s_master.*.public_ip[0]}

[kubernetes-workers]
${join("\n",
       formatlist(
         "%s",
         aws_instance.k8s_node.*.public_ip
       ))}
EOF

  filename = "${path.module}/ansible_inventory.ini"
  file_permission = "0600"
}
