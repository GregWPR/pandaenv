FROM ubuntu:18.04
WORKDIR /home
COPY agent.jar /home
RUN apt update
RUN apt install -y curl openjdk-11-jdk git maven
RUN adduser --disabled-password --gecos "" jenkins
RUN curl -fsSL https://get.docker.com |sh
RUN apt install -y python3
