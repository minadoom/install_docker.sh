#!/bin/bash

docker_package=("docker.io" "docker-compose")
printf "*************************\n*** Create by HouSeKi ***\n*************************\n"

isRoot(){
    if [ "$(id -u)" != "0" ]; then
       echo "This script must be run as root" 1>&2
       exit 1
    fi
}

update_repo(){
    echo "[+] Update Repository...this will take a few minute";
    sleep 2
    apt-get update -y
    if [ $? -eq 0 ]
    then
        echo -e "[+] Update success !\n\n"
    else
        echo "[-] ERROR on update, program exit"
    fi
}

install_all(){
    read -p "Install 'docker.io' and 'docker-compose'? [Y/n]: " prompt
    prompt="${prompt:=Y}"
    [[ $prompt =~ [Yy] ]] && apt-get install ${docker_package[@]}
}
install_dockerio(){
    read -p "Install 'docker.io' ? [Y/n]: " prompt
    prompt="${prompt:=Y}"
    [[ $prompt =~ [Yy] ]] && apt-get install ${docker_package[0]}
}
install_dockercompose(){
    read -p "Install 'docker-compose'? [Y/n]: " prompt
    prompt="${prompt:=Y}"
    [[ $prompt =~ [Yy] ]] && apt-get install ${docker_package[1]}
}

check_docker(){
    echo "####### Check installed package #######"
    sleep 2
    DOCKER_IO=$(dpkg -s docker.io &>/dev/null;echo $?)
    DOCKER_COMPOSE=$(dpkg -s docker-compose &>/dev/null;echo $?)
    if [ "$((DOCKER_IO & DOCKER_COMPOSE))" -ne 0 ]; then
        install_all
    else
        #### check docker.io
        if [ "${DOCKER_IO}" -ne 0 ]
        then
            echo -e "[-] Package 'docker.io' \e[91mnot\e[39m installed."
            install_dockerio
        else
            echo -e "[+] Package 'docker.io' \e[92malready\e[39m installed."
        fi
        #### check docker-compose
        if [ "${DOCKER_COMPOSE}" -ne 0 ]
        then
            echo -e "[-] Package 'docker-compose' \e[91mnot\e[39m installed."
            install_dockercompose
        else
            echo -e "[+] Package 'docker-compose' \e[92malready\e[39m installed."
        fi
    fi

}
isRoot
update_repo
check_docker
