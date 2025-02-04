function dotfile-update() {
    current_dir=$(pwd)
    cd ~/dotfiles
    ./install.sh
    cd $current_dir
}

function venv() {
    # Check if already activated
    if [[ "$VIRTUAL_ENV" != "/lsiopy" ]]; then
        echo -e "\n\e[1;33mDeactivating current virtual environment...\e[0m"
        deactivate
        return
    fi

    # Check if the venv directory exists
    if [ -d "venv" ]; then
        echo -e "\n\e[1;33mActivating virtual environment...\e[0m"
        source venv/bin/activate
    else
        echo -e "\n\e[1;33mCreating and activating virtual environment...\e[0m"
        python3 -m venv venv
        source venv/bin/activate
    fi
}

# general
function ..() { cd '..'; }
function ...() { cd '../..'; }
function ....() { cd '../../..'; }

# updates:
function uu() {
    set -e
    sudo apt update
    sudo apt upgrade -y
    sudo apt autoremove
}

# auto-sudo:
function please() {
    local cmd="$(fc -ln -1)"
    echo "since you asked nicely: sudo $cmd\n"
    command sudo "$cmd"
}

# docker
function dcdown() {docker compose down;}
function dcupd() {docker compose up -d;}
function dcpupd() {docker compose pull && dcupd;}
function update-docker() {
    set -e
    for i in $(ls ~/docker); do
        cd "/docker/${i}"
        docker compose pull
        docker compose up -d
    done
    docker image prune -f
}
function dive() {
    docker pull wagoodman/dive:latest
    docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock:ro wagoodman/dive:latest "$@"
}

# rsync.net
function borg1() {borg --remote-path=borg1 "$@";}
