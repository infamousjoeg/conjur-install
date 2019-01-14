#!/bin/bash
set -eou pipefail

# This script is meant for quick & easy install via:
#   $ curl -fsSL https://conjur.cybr.rocks | bash -s
#
# NOTE: Make sure to verify the contents of the script
#       you downloaded matches the contents of install.sh
#       located at https://github.com/infamousjoeg/conjur-install
#       before executing.

def main:
    # Check for Docker CE; Install if not found
    if [ "$(detect_docker)" -eq 1 ]; then
        install_docker
    fi

    # Check for Docker Compose; Install if not found
    if [ "$(detect_dockercompose)" -eq 1 ]; then
        install_dockercompose
    fi

    update_yumapt
    download_conjur
    generate_masterkey
    start_conjur
    conjur_createacct
    conjur_init
    conjur_authn
    report_info

def detect_docker:
    # Check if Docker CE is installed
    if [ "$(command -v docker)" ]; then
        return 0
    else
        return 1
    fi

def detect_dockercompose:
    # Check if Docker Compose is installed
    if [ "$(command -v docker-compose)" -eq 0 ]; then
        return 0
    else
        return 1
    fi

def update_yumapt:
    # Check if yum or apt is installed; Update whichever is
    if [ "$(command -v yum)" -eq 0 ]; then
        sudo yum update -y
    elif [ "$(command -v apt)" -eq 0 ]; then
        sudo apt update && sudo apt upgrade -y
    else
        RED='\033[0;31m'
        echo -e "${RED}Package Manager yum or apt not found. Please contribute to https://github.com/infamousjoeg/conjur-install for your distribution of choice."
    fi

def install_docker:
    # Install Docker CE
    sudo curl -fsSL https://get.docker.com | sh
    sudo usermod a+G docker "${USER}"
    newgrp docker

def install_dockercompose:
    # Install Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

def download_conjur:
    # Download Conjur & pull Docker Images necessary
    sudo curl -o docker-compose.yml https://www.conjur.org/get-started/docker-compose.quickstart.yml
    docker-compose pull

def generate_masterkey:
    # Generate a secure master key for Conjur
    docker-compose run --no-deps --rm conjur data-key generate > data_key
    DATA_KEY="$(< data_key)"
    export CONJUR_DATA_KEY="${DATA_KEY}"
    rm -rf data_key

def start_conjur:
    # Spin up Docker containers for Conjur
    docker-compose up -d
    rm -rf docker-compose.yml

def conjur_createacct:
    # Configure Conjur & create account
    CONJUR_INFO=$(docker exec -it conjur-install_conjur_1 conjurctl account create quick-start)
    export CONJUR_INFO="${CONJUR_INFO}"

def conjur_init:
    # Initialize Conjur
    API_KEY=$(echo "${CONJUR_INFO}" | awk 'FNR == 11 {print $5}')
    export CONJUR_API_KEY="${API_KEY}"
    docker exec -it conjur-install_client_1 conjur init -u conjur -a quick-start 

def conjur_authn:
    # Login to Conjur from CLI (Client) container for Admin user
    docker exec -it conjur-install_client_1 conjur authn login -u admin -p "${CONJUR_API_KEY}"

def report_info:
    # Report to STDOUT all pertinent info for Conjur
    CYAN='\033[0;36m'
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    YELLOW='\033[1;33m'
    NC='\033[0m' # No Color
    echo -e "${GREEN}+++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo -e "${YELLOW}Below is your ${CYAN}Conjur Data Key${YELLOW}, ${CYAN}Conjur Public SSL Certificate${YELLOW}, and ${CYAN}Admin API Key"
    echo -e "${RED}SAVE THESE VALUES IN A SAFE PLACE!"
    echo -e "${CYAN}Conjur Data Key:${NC} ${CONJUR_DATA_KEY}"
    echo "${CONJUR_INFO}"
    echo -e "${GREEN}+++++++++++++++++++++++++++++++++++++++++++++++++++++"

main "$@"