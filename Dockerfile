FROM ubuntu:trusty

# TERM isn't set properly in Docker shell instance for some reason
ENV TERM xterm
ENV HOME /root

# Force bash
RUN ln -snf /bin/bash /bin/sh

# add-apt-repository comes from this package
RUN apt-get update && apt-get install -y software-properties-common

RUN add-apt-repository ppa:neovim-ppa/unstable && \
    add-apt-repository ppa:pi-rho/dev && \
    apt-get update

RUN apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        build-essential \
        bzip2 \
        ca-certificates \
        curl \
        file \
        g++ \
        gcc \
        git-core \
        imagemagick \
        libbz2-dev \
        libc6-dev \
        libcurl4-openssl-dev \
        libevent-dev \
        libffi-dev \
        libglib2.0-dev \
        libjpeg-dev \
        liblzma-dev \
        libmagickcore-dev \
        libmagickwand-dev \
        libmysqlclient-dev \
        libncurses-dev \
        libpq-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        libtool \
        libxml2-dev \
        libxslt-dev \
        libxslt1-dev \
        libyaml-dev \
        libyaml-dev \
        make \
        neovim \
        openssl \
        patch \
        sqlite3 \
        tmux=2.0-1~ppa1~t \
        xz-utils \
        zlib1g-dev \
        zlib1g-dev \
        zsh 

# Setup Neovim
RUN update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60 && \
    update-alternatives --config vi && \
    update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60 && \
    update-alternatives --config vim && \
    update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60 && \
    update-alternatives --config editor

# Setup Node
RUN git clone https://github.com/creationix/nvm.git ~/.nvm && \
    cd ~/.nvm && \
    git checkout `git describe --abbrev=0 --tags`
RUN /bin/bash -c "source ~/.nvm/nvm.sh && nvm install stable && nvm use stable"

# Setup Ruby
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv && \
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    ~/.rbenv/bin/rbenv install 2.2.3

# Setup Git
RUN git config --global color.ui true && \
    git config --global user.name "Taylor LOdge" && \
    git config --global user.email "ubermouse894@gmail.com"

# Setup ZSH
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
RUN cat /dev/null && cat /dev/null && cat /dev/null && cat /dev/null
RUN git clone https://github.com/UberMouse/dotfiles.git ~/dotfiles
RUN chmod +x ~/dotfiles/link.sh
RUN /bin/bash ~/dotfiles/link.sh
# Trigger antigen install
RUN cat ~/.zshrc
RUN /bin/zsh -c "source ~/.zshrc; pwd"

# Setup Tmux & Vim Plugins
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
RUN /bin/bash ~/.tmux/plugins/tpm/bin/install_plugins

RUN curl -fLo ~/.nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    cat /dev/null #nvim -E -c 'PlugInstall' -c 'qall!'
  

VOLUME ['~/.ssh']
CMD ["tmux", "new-session", "-A", "-s", "main"]
