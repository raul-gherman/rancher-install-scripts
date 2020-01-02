#################################################################################################
### Rancher 2.3.x on Ubuntu 18.04 LTS
#################################################################################################

#################################################################################################
### !!! WARNING !!!
### THIS IS JUST A POC !!!
### ALL COMMANDS ARE ISSUED AS PRIVILEDGED USER !!!
### NOT TO BE USED IN PROD ENVS AS IS !!!
#################################################################################################

#################################################################################################
### preferred: static IP address, i.e. 192.168.74.140
### ssh server is not installed by default, it should be checked during installation process
#################################################################################################

#################################################################################################
### get the host up-to-date
#################################################################################################

sudo apt upgrade

#################################################################################################
### install pre-requisites (if not already present)
#################################################################################################

sudo apt install \
         apt-transport-https \
         ca-certificates \
         curl \
         software-properties-common

#################################################################################################
### add the GPG key for the official Docker repository to your system
#################################################################################################

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#################################################################################################
### add Docker repository to APT sources
#################################################################################################

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

sudo apt update

#################################################################################################
### Make sure you are about to install from the Docker repo instead of the default Ubuntu repo
#################################################################################################

apt-cache policy docker-ce

#################################################################################################
### install docker
#################################################################################################

sudo apt install docker-ce

#################################################################################################
### Docker should now be installed, the daemon started, and the process enabled to start on boot.
### Now heck that it’s running:
#################################################################################################

sudo systemctl status docker

#################################################################################################
### add your user to docker group, in order to be able to run docker w/o sudo
#################################################################################################

sudo usermod -aG docker ${USER}

#################################################################################################
### apply user group change
#################################################################################################

su - ${USER}

#################################################################################################
### make sure firewall is up
#################################################################################################

sudo ufw enable

#################################################################################################
### allow Rancher master required ports through firewall
### in prod, source ips should be limited to bare minimum
#################################################################################################

sudo ufw allow from any to any port 22 proto tcp
sudo ufw allow from any to any port 80 proto tcp
sudo ufw allow from any to any port 443 proto tcp
sudo ufw allow from any to any port 2376 proto tcp
sudo ufw allow from any to any port 6443 proto tcp
sudo ufw allow from any to any port 8472 proto udp
sudo ufw allow from any to any port 9099 proto tcp
sudo ufw allow from any to any port 10250 proto tcp
sudo ufw allow from any to any port 10254 proto tcp
sudo ufw allow from any to any port 8472 proto udp
sudo ufw allow from any to any port 3389 proto tcp
sudo ufw allow from any to any port 30000:32767 proto tcp
sudo ufw allow from any to any port 30000:32767 proto udp

# https://rancher.com/docs/rancher/v2.x/en/installation/references/

#################################################################################################
### enroll worker node
#################################################################################################

# sample, certain values will be different

sudo docker run -d --privileged --restart=unless-stopped --net=host -v /etc/kubernetes:/etc/kubernetes -v /var/run:/var/run rancher/rancher-agent:v2.3.3 --server https://192.168.74.138 --token 7rjv8kzqpwg2d6bq8clszpgn7d9bb2x92qhvtn7l5b4k74x4hmmzjr --ca-checksum 011a5d5e54ea1bf6ebdbd2d80f4bf08015826c2d98558fdce1121d3d3fd2994c --worker

#################################################################################################