output "jenkins_ip" {
  value = aws_instance.jenkins.public_ip
}

output "docker_ip" {
  value = aws_instance.docker.public_ip
}

output "sonarqube_ip" {
  value = aws_instance.sonarqube.public_ip
}

output "app_ip" {
  value = aws_instance.app.public_ip
}

output "k3s_ip" {
  value = aws_instance.k3s.public_ip
}

output "monitoring_ip" {
  value = aws_instance.monitoring.public_ip
}
