#!/usr/bin/env bash
sudo apt update
sudo apt install apache2 git -y
sudo systemctl start apache2
sudo systemctl enable apache2