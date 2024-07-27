#define Roles and Policies to be associated with the ec2-instance

resource "aws_iam_policy" "policy1" {
#  path = "/users/rangapv/"
  policy = "${file("./policy1.json")}"

}

resource "aws_iam_policy" "policy2" {
#  path = "/users/rangapv/"
  policy = "${file("./policy2.json")}"

}
resource "aws_iam_role" "k8s_role" {
  name = "k8s_role"
#  path = "/users/rangapv/"
#  assume_role_policy = aws_iam_policy.policy1, 
  assume_role_policy = "${file("./policy6.json")}"
  managed_policy_arns = [ aws_iam_policy.policy1.arn, aws_iam_policy.policy2.arn ]
  tags = {
    tag-key = "k8s-tf-role"
  }
}

resource "aws_iam_instance_profile" "k8s_profile" {
  name = "k8s_profile"
  role = aws_iam_role.k8s_role.name
}
