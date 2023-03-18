FROM ubuntu:latest

RUN yes | unminimize

RUN apt update -y
RUN DEBIAN_FRONTEND="noninteractive" apt install -y tzdata
RUN apt install -y \
    git-all \
    vim \
    nano \
    whois \
    openssh-server \
    curl \
    apt-utils \
    iputils-ping \
    zsh \
    tmux \
    man \
    fzf

RUN useradd --comment "GameMaster account" --create-home --password $(mkpasswd -m sha-512 94+wings+STRONG+mountain+35) gamemaster
RUN useradd --comment "Player account" --create-home --password $(mkpasswd -m sha-512 player) --shell $(which zsh) player

COPY build/player_entrypoint.sh /home/player
RUN chown player:player /home/player/player_entrypoint.sh
RUN chmod 770 /home/player/player_entrypoint.sh
RUN su -c "/home/player/player_entrypoint.sh" - player
COPY build/player_zshrc.sh /home/player/.zshrc
RUN chown player:player /home/player/.zshrc
RUN chmod 770 /home/player/.zshrc

RUN mkdir /var/run/sshd
COPY build/sshd_config /etc/ssh/sshd_config
COPY build/login_banner.txt /etc/motd
COPY build/.bashrc ~/.bashrc 

RUN /etc/init.d/ssh start && ssh-keyscan -H localhost >> /home/player/.ssh/known_hosts && ssh-keyscan -H localhost

RUN git clone --bare https://github.com/collinzurfluh1/EWU_GIT_CTF_LEVELS.git /home/gamemaster/ctf-repo

RUN git clone --bare https://github.com/collinzurfluh1/EWU_GIT_CTF_LEVELS.git /home/gamemaster/forked-ctf-repo
COPY build/gamemaster_entrypoint.sh /home/gamemaster
RUN chown gamemaster:gamemaster /home/gamemaster/gamemaster_entrypoint.sh
RUN chmod 770 /home/gamemaster/gamemaster_entrypoint.sh
RUN chown --recursive gamemaster:gamemaster /home/gamemaster

ARG CACHE_DATE
RUN ls -la "/home/gamemaster"
RUN su -c "/home/gamemaster/gamemaster_entrypoint.sh" - gamemaster

COPY levels/checkers /home/gamemaster/ctf-repo/hooks/checkers
COPY scripts/output/pre-receive /home/gamemaster/ctf-repo/hooks
RUN chown -R gamemaster:gamemaster /home/gamemaster

RUN chsh gamemaster -s $(which git-shell)
RUN chmod 700 -R /home/gamemaster

RUN rm -rf /tmp/*
RUN rm -rf /home/player/player_entrypoint.sh
RUN echo 'function ewugithelp { echo "Basic Git Commands: https://dzone.com/articles/top-20-git-commands-with-examples    Rebase example: https://git-scm.com/book/en/v2/Git-Branching-Rebasing"; }' >> ~/.bashrc

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
