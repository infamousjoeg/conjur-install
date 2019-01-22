#!/bin/bash
set -eou pipefail

if [ "$(command -v apt)" ]; then
    sudo apt update && sudo apt upgrade -y
    sudo apt install python2.7 python-pip -y
    pip install ansible
    ansible-galaxy install geerlingguy.pip
    ansible-galaxy install geerlingguy.docker
elif [ "$(command -v yum)" ]; then
    sudo yum upgrade -y
    sudo yum install gcc openssl-devel bzip2-devel wget curl -y
    pushd /usr/src
        sudo wget https://www.python.org/ftp/python/2.7.15/Python-2.7.15.tgz
        sudo tar xzf Python-2.7.15.tgz
    popd
    pushd /usr/src/Python-2.7.15
        sudo ./configure --enable-optimizations
        sudo make altinstall
    popd
    curl -fsSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    sudo python2.7 get-pip.py
    rm -f get-pip.py
    sudo pip install ansible
    ansible-galaxy install geerlingguy.pip
    ansible-galaxy install geerlingguy.docker
fi

ansible-playbook -i localhost, -K install.yml