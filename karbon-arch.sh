#!/usr/bin/env sh

procMsg() {
    echo -e "\n###\n#\n# $1\n#\n###\n\n"
}

alarmMsg() {
    echo -e "\n!!! $1 !!!\n\n"
}

getRepos() {
    if ! [ -f ~/.gitconfig ]
    then
        git config --global credential.helper store
    fi

    if ! [ -d ~/git ]
    then
        mkdir ~/git
    fi

    repos=(
        "clitter-appsscript"
        "gradius"
        "gldap"
        "gstunnel"
        "gasp"
        "goat"
        "docker-nginx-vpn"
        "karbon"
        "fuzzydl"
        "docker-openvpn"
        "gapic"
        "xurl"
        "sysprobe"
        "dumpt"
        "doxi"
        "alpine"
        "gitd"
        "rpi4-stack"
        "sfq"
        "labeld"
        "goauth-web"
        "goauth-cli"
	    "gws-transfertool"
	    "meta"
	    "alpinedev"
	    "gcc10-alpine-package"
	    "hashclock"
	    "bazel-docker"
    )

    curdir=`pwd`

    cd ~/git/

    for ((i=1 ; i<=${#repos[@]} ; i++))
    do
        echo "Checking out github.com/ZalgoNoise/${repos[i]}"
        if ! [ -d "${HOME}/git/${repos[i]}" ]
        then
            git clone https://github.com/ZalgoNoise/${repos[i]} ${HOME}/git/${repos[i]}
        fi

    done

    cd $curdir
}



getPackages() {
    packages=(
        "tmux"
        "vim"
        "zsh"
        "openssh"
        "jq"
        "nmap"
        "go"
        "clang"
        "python3"
        "nodejs"
        "npm"
        "code"
        "docker"
        "docker-compose"
        "chromium"
        "oh-my-zsh"
        "zsh-syntax-highlighting"
        "zsh-completions"
        "zsh-autosuggestions"
        "ttf-meslo-nerd-font-powerlevel10k"
        "zsh-theme-powerlevel10k"
    )

    sudo pamac remove \
        liblrdf \
        thunderbird

    sudo pamac install \
        --no-confirm \
        --upgrade \
        ${packages[@]} \
    && setShell

}

getVim() {
    git clone --depth=1 https://github.com/amix/vimrc.git ${HOME}/.vim_runtime
    (sh ~/.vim_runtime/install_awesome_vimrc.sh)
}

getTmux() {
    git clone https://github.com/gpakosz/.tmux.git ${HOME}/.tmux
    ln -s ${HOME}/.tmux/.tmux.conf ${HOME}/.tmux.conf
    cp ${HOME}/.tmux/.tmux.conf.local ${HOME}/.
}

setupGo() {
    if ! [[ -d /usr/local/go ]]
    then
        mkdir -p /usr/local/go/bin
    fi

    if [[ -z $(echo $PATH | grep '/usr/local/go/bin') ]]
    then
        sudo cat << EOF > /tmp/profile
$(cat /etc/profile)
export PATH=${PATH}:/usr/local/go/bin:$(go env GOPATH)/bin
export GOPATH=$(go env GOPATH)
EOF

        sudo mv /tmp/profile /etc/profile
    fi
}

getBazel() {
    go install github.com/bazelbuild/bazelisk@latest
}

setShell() {
    chsh zalgo -s /bin/zsh
}

cd
procMsg "Updating and getting packages"
getPackages

procMsg "Feching Github repos"
getRepos

if ! [ -d ~/.vim_runtime ]
then
    alarmMsg "Vim isn't setup yet"
    procMsg "Setting up Vim"
    getVim
else
    procMsg "Vim OK!"
fi

if ! [ -d ~/.tmux ]
then
    alarmMsg "Tmux isn't setup yet"
    procMsg "Setting up Tmux"
    getTmux
else
    procMsg "Tmux OK!"
fi

if ! [[ $(which bazel) ]]
then
    alarmMsg "Bazel isn't setup yet"
    procMsg "Setting up Bazel with Bazelisk"
    getBazel
else
    procMsg "Bazel OK!"
fi

procMsg "All set up!"
