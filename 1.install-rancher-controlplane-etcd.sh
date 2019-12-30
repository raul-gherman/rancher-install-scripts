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
### required: static IP address, i.e. 192.168.74.102
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
### allow required etcd node ports through firewall
###################################################################

firewall-cmd --zone=public --add-port=443/tcp   --permanent
firewall-cmd --zone=public --add-port=2376/tcp  --permanent
firewall-cmd --zone=public --add-port=2379/tcp  --permanent
firewall-cmd --zone=public --add-port=2380/tcp  --permanent
firewall-cmd --zone=public --add-port=6443/tcp  --permanent
firewall-cmd --zone=public --add-port=8472/udp  --permanent
firewall-cmd --zone=public --add-port=9099/tcp  --permanent
firewall-cmd --zone=public --add-port=10250/tcp --permanent
firewall-cmd --reload

###################################################################
### allow required controlplane node ports through firewall
###################################################################

firewall-cmd --zone=public --add-port=80/tcp          --permanent
firewall-cmd --zone=public --add-port=443/tcp         --permanent
firewall-cmd --zone=public --add-port=2376/tcp        --permanent
firewall-cmd --zone=public --add-port=2379/tcp        --permanent
firewall-cmd --zone=public --add-port=2380/tcp        --permanent
firewall-cmd --zone=public --add-port=6443/tcp        --permanent
firewall-cmd --zone=public --add-port=8472/udp        --permanent
firewall-cmd --zone=public --add-port=9099/tcp        --permanent
firewall-cmd --zone=public --add-port=10250/tcp       --permanent
firewall-cmd --zone=public --add-port=10254/tcp       --permanent
firewall-cmd --zone=public --add-port=30000-32767/tcp --permanent
firewall-cmd --zone=public --add-port=30000-32767/udp --permanent
firewall-cmd --reload

# https://rancher.com/docs/rancher/v2.x/en/installation/references/

###################################################################
### enroll controlplane and etcd server node
###################################################################

# sample, certain values will be different

docker run -d \
           --privileged \
           --restart=unless-stopped \
           --net=host \
           -v /etc/kubernetes:/etc/kubernetes \
           -v /var/run:/var/run rancher/rancher-agent:v2.3.3 \
           --server https://192.168.74.101 \
           --token cmkfgcbm86m98gzqsthzhx79ztslvbdq4zwvvdvkwn57x8j68mwrrh \
           --ca-checksum 7b66ae17b5d204abc0ea5eedc68c1645ff3e163ecb4dcf5e2ff30b4280f36824 \
           --etcd \
           --controlplane

###################################################################