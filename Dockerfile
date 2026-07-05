# Dockerfile
FROM archlinux:latest

# Build arguments for user configuration
ARG USER_NAME=developer
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG HOME_DIR=/home/developer

# Set environment variables - Keep these
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TERM=xterm-256color \
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics

# ✅ GENERATE LOCALE FIRST - before installing packages
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen && \
    echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Now install packages - locale will work
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
    base-devel \
    git \
    curl \
    wget \
    vim \
    nano \
    python \
    python-pip \
    nodejs \
    npm \
    openssh \
    sudo \
    which \
    net-tools \
    iputils \
    dnsutils \
    htop \
    ncdu \
    ripgrep \
    fd \
    jq \
    yq \
    unzip \
    zip \
    tar \
    gzip \
    nvidia-utils \
    libglvnd \
    openai-codex \
    systemd \
    && pacman -Scc --noconfirm

# Create user with specified UID/GID
RUN groupadd -g ${GROUP_ID} ${USER_NAME} && \
    useradd -m -u ${USER_ID} -g ${GROUP_ID} -G wheel -s /bin/bash ${USER_NAME} && \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install yay (AUR helper) as the new user
RUN cd /tmp && \
    git clone https://aur.archlinux.org/yay.git && \
    chown -R ${USER_NAME}:${USER_NAME} yay && \
    cd yay && \
    sudo -u ${USER_NAME} makepkg -si --noconfirm && \
    cd / && rm -rf /tmp/yay

# Install CUDA from AUR (optional)
RUN sudo -u ${USER_NAME} yay -S --noconfirm cuda || echo "CUDA installation skipped"

# Switch to the new user
USER ${USER_NAME}

# Set working directory
WORKDIR ${HOME_DIR}

# Default command
CMD ["/bin/bash"]
