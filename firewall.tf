resource "aws_security_group" "egress" {
  name       = "${var.env_name}-egress"
  vpc_id     = "${aws_vpc.main.id}"
  depends_on = ["aws_route_table_association.main"]
}

resource "aws_security_group_rule" "allow_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.egress.id}"
}

resource "aws_security_group" "admin" {
  name   = "${var.env_name}-admin"
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.admin.id}"
}

resource "aws_security_group" "internal" {
  name   = "${var.env_name}-internal"
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_security_group_rule" "allow_all_cluster" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.internal.id}"
  security_group_id        = "${aws_security_group.internal.id}"
}
