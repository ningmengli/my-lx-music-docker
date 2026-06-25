# 更换为 Ubuntu 22.04 基础镜像，软件源正常，仍在长期支持期
FROM dorowu/ubuntu-desktop-lxde-vnc:jammy

LABEL description="LX Music Desktop noVNC Docker"

# 安装运行依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    libnss3 \
    libatk-bridge2.0-0 \
    libdrm2 \
    libxkbcommon0 \
    libgbm1 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

# 下载安装洛雪音乐桌面版 v2.12.2，增加重试机制避免网络波动
RUN wget --tries=3 --timeout=30 -O /tmp/lx-music.deb \
    "https://github.com/lyswhut/lx-music-desktop/releases/download/v2.12.2/lx-music-desktop_2.12.2_amd64.deb" \
    && dpkg -i /tmp/lx-music.deb \
    && rm /tmp/lx-music.deb

# 创建下载目录
RUN mkdir -p /downloads

# 开机自动启动洛雪音乐
RUN echo "lx-music-desktop --no-sandbox &" >> /root/.config/lxsession/LXDE/autostart
