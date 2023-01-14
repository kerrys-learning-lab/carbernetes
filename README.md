[Optional] Manually perform maintenance actions
$ ssh rpi
$ sudo apt dist-upgrade -y
$ sudo systemctl reboot

Automate maintenance and configuration:

Add IP to inventory.yaml

Verify access [host]
$ ansible -i ansible/inventory.yaml all -m ping
$ ansible-playbook -i ansible/inventory.yaml ansible/playbook.yaml


References:

https://opensource.com/article/20/9/raspberry-pi-ansible

https://hub.docker.com/r/geerlingguy/docker-debian10-ansible

https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible

https://www.digitalocean.com/community/tutorials/how-to-use-ansible-to-install-and-set-up-docker-on-ubuntu-20-04 