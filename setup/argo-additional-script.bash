kubectl create secret generic homelab-github-ssh   --namespace argocd   --from-literal=url=git@github.com:bro-adm/home-lab.git   --from-file=sshPrivateKey=./id_rsa 
