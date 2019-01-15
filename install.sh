#!/bin/bash
set -e pipefail

# This script is meant for quick & easy install via:
#   $ curl -fsSL https://cybr.rocks/conjur-install | bash -s
#
# NOTE: Make sure to verify the contents of the script
#       you downloaded matches the contents of install.sh
#       located at https://github.com/infamousjoeg/conjur-install
#       before executing.
#       e.g. $ curl -fsSL https://cybr.rocks/conjur-install -o conjur-install.sh
#            $ ./conjur-install.sh

main () {
    update_yumapt
    install_docker
    install_dockercompose
    download_conjur
    generate_masterkey
    start_conjur
    sleep 8
    conjur_createacct
    conjur_init
    conjur_authn
    report_info
}

update_yumapt () {
    # Check if yum or apt is installed; Update whichever is
    if [ "$(command -v yum)" ]; then
        set -x
        sudo yum update -y
        set +x
    elif [ "$(command -v apt)" ]; then
        set -x
        sudo apt update && sudo apt upgrade -y
        set +x
    else
        RED='\033[0;31m'
        NC='\033[0m' # No Color
        echo -e "${RED}Package Manager yum or apt not found. Please contribute to https://github.com/infamousjoeg/conjur-install for your distribution of choice.${NC}"
    fi
}

install_docker () {
    # Check if Docker CE is installed
    if [ -z "$(command -v docker)" ]; then
        # Install Docker CE
        set -x
        sudo curl -fsSL https://get.docker.com | sh
        sudo usermod -aG docker "${USER}"
        set +x
    fi
}

install_dockercompose () {
    # Check if Docker Compose is installed
    if [ -z  "$(command -v docker-compose)" ]; then
        # Install Docker Compose
        set -x
        sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        set +x
    fi
}

download_conjur () {
    # Download Conjur & pull Docker Images necessary
    set -x
    sudo curl -o docker-compose.yml https://www.conjur.org/get-started/docker-compose.quickstart.yml
    sudo docker-compose pull
    set +x
}

generate_masterkey () {
    # Generate a secure master key for Conjur
    set -x
    sudo docker-compose run --no-deps --rm conjur data-key generate | sudo tee data_key > /dev/null
    set +x
    DATA_KEY="$(< data_key)"
    sed -e "s#CONJUR_DATA_KEY:#CONJUR_DATA_KEY: ${DATA_KEY}#" docker-compose.yml > docker-compose-new.yml
    mv -f docker-compose-new.yml docker-compose.yml
    export CONJUR_DATA_KEY="${DATA_KEY}"
    rm -rf data_key
}

start_conjur () {
    # Spin up Docker containers for Conjur
    set -x
    sudo docker-compose up -d
    set +x
    rm -rf docker-compose.yml
}

conjur_createacct () {
    # Configure Conjur & create account
    CONJUR_INFO=$(sudo docker exec -i "${USER}"_conjur_1 conjurctl account create quick-start)
    export CONJUR_INFO="${CONJUR_INFO}"
}

conjur_init () {
    # Initialize Conjur
    API_KEY=$(echo "${CONJUR_INFO}" | awk 'FNR == 11 {print $5}')
    export CONJUR_API_KEY="${API_KEY}"
    set -x
    sudo docker exec -i "${USER}"_client_1 conjur init -u conjur -a quick-start 
    set +x
}

conjur_authn () {
    # Login to Conjur from CLI (Client) container for Admin user
    set -x
    sudo docker exec -i "${USER}"_client_1 conjur authn login -u admin -p "${CONJUR_API_KEY}"
    set +x
}

report_info () {
    # Report to STDOUT all pertinent info for Conjur
    CYAN='\033[0;36m'
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    YELLOW='\033[1;33m'
    NC='\033[0m' # No Color
    echo -e "${GREEN}+++++++++++++++++++++++++++++++++++++++++++++++++++++${NC}"
    echo -e "${RED}SAVE THESE VALUES IN A SAFE PLACE!${NC}"
    echo -e "${GREEN}+++++++++++++++++++++++++++++++++++++++++++++++++++++${NC}"
    echo -e "${CYAN}Conjur Data Key:${NC} ${YELLOW}${CONJUR_DATA_KEY}${NC}"
    echo -e "${CYAN}Conjur Public SSL Certificate & Admin API Key:${YELLOW}"
    echo -e "${CONJUR_INFO}"
    echo -e "${GREEN}+++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo -e "${NC}Your Conjur environment is running in Docker: ${CYAN}sudo docker ps${NC}"
    sudo docker ps
    echo -e "${GREEN}+++++++++++++++++++++++++++++++++++++++++++++++++++++${NC}"
}

main "$@"
