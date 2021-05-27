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
    )

    curdir=`pwd`

    cd ~/git/

    for ((i=1 ; i<=${#repos[@]} ; i++))
    do
        echo "Checking github.com/ZalgoNoise/${repos[i]}"
        if ! [ -d "${HOME}/git/${repos[i]}" ]
        then
            git clone https://github.com/ZalgoNoise/${repos[i]} ${HOME}/git/${repos[i]}
        fi

    done

    cd $curdir
}



getPackages() {

    sudo pacman -Syu \
    git \
    tmux \
    vim \
    zsh \
    openssh \
    mutt \
    rclone \
    jq \
    nmap \
    golang \
    bazel \
    clang
}

getZsh() {
    git clone https://github.com/robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh
    cp ${HOME}/.oh-my-zsh/templates/zshrc.zsh-template ${HOME}/.zshrc
    sudo chsh -s /bin/zsh ${USER}
}

getZshGoodies() {
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.oh-my-zsh/plugins/zsh-syntax-highlighting" --depth 1
    git clone https://github.com/zsh-users/zsh-completions.git "${HOME}/.oh-my-zsh/plugins/zsh-completions" --depth 1
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "${HOME}/.oh-my-zsh/plugins/zsh-autosuggestions/" --depth 1
    sed -i -e "71s/[^[]*/plugins=(git zsh-syntax-highlighting zsh-completions zsh-autosuggestions)/g" ${HOME}/.zshrc
}

getPowerlevel10k() {
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
    sed -i -e "11s/[^[]*/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/g" ${HOME}/.zshrc
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

cd
procMsg "Updating and getting packages"
getPackages

procMsg "Feching Github repos"
getRepos


if ! [ -d ~/.oh-my-zsh ]
then
    alarmMsg "Oh-my-zsh isn't setup yet"
    procMsg "Setting up Oh-my-zsh"
    getZsh
else
    procMsg "Oh-My-Zsh OK!"
fi

if ! [ -d ~/.oh-my-zsh/plugins/zsh-syntax-highlighting ] \
|| ! [ -d ~/.oh-my-zsh/plugins/zsh-completions ] \
|| ! [ -d ~/.oh-my-zsh/plugins/zsh-autosuggestions ]
then
    alarmMsg "Zsh goodies aren't setup yet"
    procMsg "Setting up Zsh goodies"
    getZshGoodies
else
    procMsg "Zsh goodies OK!"
fi


if ! [ `grep "powerlevel10k" ~/.zshrc` ]
then
    alarmMsg "Powerlevel10k isn't setup yet"
    procMsg "Setting up Powerlevel10k"
    getPowerlevel10k
else
    procMsg "Powerlevel10k OK!"
fi


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

procMsg "All set up!"
