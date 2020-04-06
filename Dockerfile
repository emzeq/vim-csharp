FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-256color

WORKDIR /root 

# common tools
RUN apt-get update \
    && apt-get install -y curl git apt-transport-https wget python3-dev python-dev tmux silversearcher-ag

# vim
RUN apt-get update \
    && apt-get install -y libncurses5-dev libncursesw5-dev build-essential \
    && git clone https://github.com/vim/vim.git \
    && cd vim/src \
    && ./configure --with-features=huge --enable-pythoninterp --enable-python3interp \
    && make \
    && make install \
    && rm -rf /root/vim

# vim-plug
RUN curl -fLo ./.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# fugitive.vim
RUN mkdir -p ./.vim/pack/tpope/start \
    && cd ./.vim/pack/tpope/start \
    && git clone https://tpope.io/vim/fugitive.git \
    && vim -u NONE -c "helptags fugitive/doc" -c q

# node.js
RUN apt-get update \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash \
    && apt-get install -y nodejs

# .NET Core 3.1
RUN wget -q https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y dotnet-sdk-3.1 \
    && rm packages-microsoft-prod.deb

# base16 shell
RUN git clone https://github.com/chriskempson/base16-shell.git ./.config/base16-shell \
    && echo '# Base16 Shell\n\
    BASE16_SHELL="$HOME/.config/base16-shell/"\n\
    [ -n "$PS1" ] && [ -s "$BASE16_SHELL/profile_helper.sh" ] && eval "$("$BASE16_SHELL/profile_helper.sh")"' >> ./.bashrc

COPY .vimrc .
COPY .tmux.conf .
COPY omnisharp.json ./.omnisharp/

CMD ["tmux"]