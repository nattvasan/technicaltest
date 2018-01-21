#!/bin/bash
scp -C -i <private_key>.pem   default  ubuntu@zz.zz.zz.zz:
cat default | sudo tee -a /etc/nginx/sites-available/default
sudo service nginx restart
