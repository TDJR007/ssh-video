FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    openssh-server \
    iputils-ping \
    net-tools \
    iproute2 \
    bash-completion \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Create ssh user with password "root"
RUN useradd -m -s /bin/bash devuser && echo "devuser:root" | chpasswd

# Add a shell profile
ENV TERM=xterm-256color
RUN echo 'export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "' >> /home/devuser/.bashrc
RUN echo 'source /usr/share/bash-completion/bash_completion' >> /home/devuser/.bashrc

# SSH config - allow password auth (fine for demo)
RUN mkdir /var/run/sshd
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Drop a sample file we'll SCP around
RUN echo "Hello from Ubuntu VM" > /home/devuser/hello.txt
RUN chown devuser:devuser /home/devuser/hello.txt

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
