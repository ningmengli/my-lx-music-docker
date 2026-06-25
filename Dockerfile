# 使用确定存在的 Ubuntu 20.04 基础镜像
FROM dorowu/ubuntu-desktop-lxde-vnc:focal

LABEL description="LX Music Desktop noVNC Docker"

# 修复：替换为官方旧版归档源，解决 Ubuntu 20.04 软件源下架问题
RUN sed -i 's/archive.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list \
    && sed -i 's/security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list

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

# 下载安装洛雪音乐，增加重试机制避免网络波动
RUN wget --tries=3 --timeout=30 -O /tmp/lx-music.deb \
    "https://github.com/lyswhut/lx-music-desktop/releases/download/v2.12.2/lx-music-desktop_2.12.2_amd64.deb" \
    && dpkg -i /tmp/lx-music.deb \
    && rm /tmp/lx-music.deb

# 创建下载目录
RUN mkdir -p /downloads

# 开机自动启动洛雪音乐
RUN echo "lx-music-desktop --no-sandbox &" >> /root/.config/lxsession/LXDE/autostart
