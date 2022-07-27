#!/bin/bash
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update && sudo apt upgrade -y
sudo apt install default-jre -y
sudo apt install openjdk-11-jdk -y
sudo apt install maven -y
sudo apt install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo apt install unzip
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
sudo sh -c 'echo deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main > /etc/apt/sources.list.d/pgdg.list'
sudo apt install postgresql postgresql-contrib -y
#sudo apt install postgresql-14
sudo systemctl enable postgresql
sudo systemctl start postgresql
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.4.0.54424.zip
unzip sonarqube-9.4.0.54424.zip
sudo mv sonarqube-*/  /opt/sonarqube
rm  -rf sonarqube*
sudo groupadd sonar
sudo useradd -d /opt/sonarqube -g sonar sonar
sudo chown sonar:sonar /opt/sonarqube -R
sudo bash -c 'cat > /opt/sonarqube/conf/sonar.properties' << EOF
sonar.jdbc.username=sonar
sonar.jdbc.password=123
sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube
sonar.web.port=9000
EOF
echo -e "RUN_AS_USER=sonar" | sudo tee -a /opt/sonarqube/bin/linux-x86-64/sonar.sh
sudo sysctl -w vm.max_map_count=262144
sudo bash -c 'cat > /etc/systemd/system/sonar.service' << EOF
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always

LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOF

