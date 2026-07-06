####################################
# DB Subnet Group
####################################

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "assessment-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  tags = {
    Name = "assessment-db-subnet-group"
  }
}

####################################
# PostgreSQL RDS
####################################

resource "aws_db_instance" "postgres" {

  identifier = "assessment-postgres"

  engine         = "postgres"
  engine_version = "16.3"

  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "hoteldb"

  username = var.db_username
  password = var.db_password

  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  publicly_accessible = false

  multi_az = false

  skip_final_snapshot = true

  deletion_protection = false

  backup_retention_period = 7

  tags = {
    Name = "assessment-postgres"
  }
}
