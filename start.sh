#!/bin/bash
sudo useradd -u 1030 artifactory
sudo chown -R artifactory:artifactory ./volumes/artifactory
sudo chown -R 1000:1000 ./volumes/jenkins
cd compose
docker-compose up -d --build
