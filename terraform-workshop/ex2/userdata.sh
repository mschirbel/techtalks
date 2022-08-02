#!/bin/bash

# SSM Agent
sudo yum install -y https://s3.${region}.amazonaws.com/amazon-ssm-${region}/latest/linux_arm64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl restart amazon-ssm-agent

# Nginx
sudo amazon-linux-extras install nginx1 -y
sudo systemctl status nginx
sudo systemctl enable nginx
sudo systemctl restart nginx

# create custom index.html
{
echo "<html>"
echo "<body>"
echo "<h1>Hello, This is my random number: ${random_number}</h1>"
echo "</body>"
echo "</html>"
} > /usr/share/nginx/html/index.html

nginx -s reload
