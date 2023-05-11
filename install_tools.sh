# To install java,jnekins,Nginx,Apache maven.
#!/bin/bash
### install jenkins
`sudo apt-get update -y`
`curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \ /usr/share/keyrings/jenkins-keyring.asc > /dev/null`
`echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \ https://pkg.jenkins.io/debian-stable binary/ | sudo tee \ /etc/apt/sources.list.d/jenkins.list > /dev/null`
`sudo apt-get install -y jenkins`
`sudo systemctl enable jenkins`
`sudo systemctl start jenkins`
`sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
### install java
`sudo apt-get update -y`
`sudo apt-get install -y openjdk-17-jdk`
### install nginx
`sudo apt-get install nginx -y`
`sudo systemctl enable nginx`
`sudo systemctl start nginx` 
### Download Apache Maven
`sudo apt-get install maven -y`
`sudo mvn --version`
