###################################################################
### Rancher 2.3.x on CEntOS 7.7
###################################################################

###################################################################
### !!! WARNING !!!
### THIS IS JUST A POC !!!
### ALL COMMANDS ARE ISSUED AS ROOT
### NOT TO BE USED IN PROD ENVS AS IS !!!
###################################################################

###################################################################
### required: static IP address, i.e. 192.168.74.101
###################################################################

###################################################################
### get the host up-to-date
###################################################################

yum update -y

###################################################################
### install pre-requisites
###################################################################

yum install -y \
    yum-utils \
    device-mapper-persistent-data \
    lvm2

###################################################################
### add docker-ce repo
###################################################################

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

###################################################################
### install docker
###################################################################

yum install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io

###################################################################
### enable docker daemon
###################################################################

systemctl enable docker

###################################################################
### start docker daemon
###################################################################

systemctl start docker

###################################################################
### allow Rancher master required ports through firewall
###################################################################

firewall-cmd --zone=public --add-port=22/tcp   --permanent
firewall-cmd --zone=public --add-port=80/tcp   --permanent
firewall-cmd --zone=public --add-port=443/tcp  --permanent
firewall-cmd --zone=public --add-port=2376/tcp --permanent
firewall-cmd --zone=public --add-port=6443/tcp --permanent
firewall-cmd --reload

# https://rancher.com/docs/rancher/v2.x/en/installation/references/

###################################################################
### launch Rancher
###################################################################

docker run -d \
           --restart=unless-stopped \
           -p 80:80 -p 443:443 \
           rancher/rancher:latest

###################################################################
### hit Rancher homepage, i.e.: https://my-rancher-master
###################################################################

###################################################################