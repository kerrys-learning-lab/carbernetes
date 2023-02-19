# Configuring a Raspberry Pi using Ansible
NOTE: If using VSCode, template files should be copied automatically upon
      initializing the devcontainer. *Values must still be updated manually*

* Copy files from .templates/ansible/config to ansible/config
* Add IP to ansible/config/inventory.yaml
* Update ansible/config/vars.yaml
* Verify ansible access from the host to the pi:
  ```
    user@host:~ $ ansible -i ansible/config/inventory.yaml all -m ping
  ```
* Execute the ansible playbook
  ```
    user@host:~ $ ansible-playbook -i ansible/config/inventory.yaml \
                                      ansible/main-rpi-playbook.yaml
  ```

# Connecting to ArgoCD (on the pi)

### Accessing ArgoCD Web UI from the *host*

* Port-forward from the host to the ArgoCD service within the k8s cluster
  ```
    user@host:~ $ kubectl -n argocd port-forward svc/argo-cd-argocd-server 8080:443
  ```
* Open a browser to http://localhost:8080 (on the host)
* Username: admin
* Password:
  ```
    user@host:~ $ kubectl -n argocd get secrets argocd-initial-admin-secret --template={{.data.password}} | base64 -d; echo
  ```


### Accessing ArgoCD CLI from the *devcontainer*

* Port-forward from the devcontainer to the ArgoCD service within the k8s cluster
  ```
    vscode ➜ /workspace $ kubectl -n argocd port-forward svc/argo-cd-argocd-server 8080:443
  ```
*
  ```
    user@host:~ $ argocd login localhost:8080

    # or

    user@host:~ $ argocd login localhost:8080 \
                    --username admin \
                    --password $(./bin/argocd-admin-secret.sh)
  ```
* Username: admin
* Password:
  ```
    user@host:~ $ kubectl -n argocd get secrets argocd-initial-admin-secret --template={{.data.password}} | base64 -d; echo
  ```

### Syncing the ArgoCD application

`argocd app sync carbernetes --revision <rev>`

E.g. `argocd app sync carbernetes --revision $(git rev-parse --short HEAD)`

# Miscellaneous

### Test access to in-cluster service from outside the cluster
NOTE: Assumes an ingress exists at <xyz-service>

```
user@host:~ $ kubectl -n c9s port-forward svc/pca9685-service 9999:9999

# The --resolve option eliminates the need to update /etc/hosts
user@host:~ $ curl --resolve raspberrypi.local:9999:127.0.0.1 http://raspberrypi.local:9999/pca9685/ping
```

### Commit, push, and update ArgoCD
`git commit -a -F .cz-commit-message && git push origin $(git rev-parse --abbrev-ref HEAD) && argocd app sync carbernetes --revision $(git rev-parse --short HEAD)`

# Troubleshooting

### No route to host 10.152.183.1 (kubernetes service)

Restart the iptables on the rpi:
```
pi@raspberrypi:~ $ sudo iptables --flush
pi@raspberrypi:~ $ sudo iptables --table nat --flush

# or
user@host:~ $ ansible-playbook -i ansible/config/inventory.yaml \
                                  ansible/restart-iptables-playbook.yaml
```

References:

https://opensource.com/article/20/9/raspberry-pi-ansible

https://hub.docker.com/r/geerlingguy/docker-debian10-ansible

https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible

https://www.digitalocean.com/community/tutorials/how-to-use-ansible-to-install-and-set-up-docker-on-ubuntu-20-04
