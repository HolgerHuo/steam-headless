FROM archlinux:latest

RUN sed -i '/^NoExtract/d' /etc/pacman.conf \
    && printf "[multilib]\nInclude = /etc/pacman.d/mirrorlist\n" >> /etc/pacman.conf

RUN --mount=type=cache,target=/var/cache/pacman/pkg,sharing=locked \
    --mount=type=cache,target=/var/lib/pacman/sync,sharing=locked \
    pacman -Syu --noconfirm glibc \
    && echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen \
    && LC_ALL=C locale-gen

ENV LANG=en_US.UTF-8

RUN --mount=type=cache,target=/var/cache/pacman/pkg,sharing=locked \
    --mount=type=cache,target=/var/lib/pacman/sync,sharing=locked \
    pacman -Syu --noconfirm --needed \
        bash \
        bash-completion \
        bzip2 \
        ca-certificates \
        curl \
        fish \
        git \
        htop \
        jq \
        less \
        lm_sensors \
        man-db \
        nvtop \
        net-tools \
        p7zip \
        pciutils \
        procps \
        psmisc \
        rsync \
        sudo \
        unzip \
        vim \
        wget \
        xz \
        supervisor \
        python \
        python-pip \
        python-pyudev \
        python-setuptools

RUN --mount=type=cache,target=/var/cache/pacman/pkg,sharing=locked \
    --mount=type=cache,target=/var/lib/pacman/sync,sharing=locked \
    pacman -Syu --noconfirm --needed \
        noto-fonts \
        noto-fonts-cjk \
        noto-fonts-emoji \
        noto-fonts-extra \
        ttf-liberation \
        ttf-vlgothic

RUN --mount=type=cache,target=/var/cache/pacman/pkg,sharing=locked \
    --mount=type=cache,target=/var/lib/pacman/sync,sharing=locked \
    pacman -Syu --noconfirm --needed \
        dbus \
        lib32-fontconfig \
        fuse2 \
        xorg-xwayland \
        seatd \
        alsa-utils \
        pavucontrol \
        pipewire \
        pipewire-alsa \
        pipewire-jack \
        pipewire-pulse \
        wireplumber \
        labwc \
        libinput-tools \
        waybar \
        fuzzel \
        foot \
        mako \
        wlr-randr \
        gvfs \
        pcmanfm \
        xarchiver \
        xdg-desktop-portal-wlr \
        xdg-desktop-portal-gtk \
        xdg-user-dirs \
        xdg-utils \
        firefox \
        gst-libav \
        gst-plugins-bad \
        gst-plugins-base \
        gst-plugins-good \
        gst-plugins-ugly \
        lib32-vulkan-icd-loader \
        lib32-vulkan-intel \
        lib32-vulkan-radeon \
        libva \
        libva-mesa-driver \
        libva-intel-driver \
        libva-utils \
        vdpauinfo \
        vulkan-icd-loader \
        vulkan-intel \
        vulkan-radeon \
        vulkan-tools

RUN --mount=type=cache,target=/var/cache/pacman/pkg,sharing=locked \
    --mount=type=cache,target=/var/lib/pacman/sync,sharing=locked \
    pacman -Syu --noconfirm --needed \
        lib32-mangohud \
        gamescope \
        mangohud \
        steam \
    && setcap 'CAP_SYS_NICE=eip' $(command -v gamescope)

RUN --mount=type=cache,target=/var/cache/pacman/pkg,sharing=locked \
    --mount=type=cache,target=/var/lib/pacman/sync,sharing=locked \
    cp /etc/pacman.conf /tmp/pacman-lizardbyte.conf \
    && printf "[lizardbyte]\nSigLevel = Optional\nServer = https://github.com/LizardByte/pacman-repo/releases/latest/download\n" >> /tmp/pacman-lizardbyte.conf \
    && pacman --config /tmp/pacman-lizardbyte.conf -Syu --noconfirm --needed lizardbyte/sunshine \
    && rm -f /tmp/pacman-lizardbyte.conf

RUN useradd -d /home/player -G input,video,render player \
    && echo "player ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY overlay /

ENV PUID="1000" \
    PGID="1000" \
    UMASK="0022" \
    TZ="Asia/Singapore" \
    USER_LOCALES="en_US.UTF-8 UTF-8" \
    PIPEWIRE_LATENCY="512/48000" \
    PIPEWIRE_RENICE="-10"

ENTRYPOINT ["/entrypoint.sh"]
