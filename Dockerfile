FROM dorowu/ubuntu-desktop-lxde-vnc:focal

LABEL description="LX Music Desktop noVNC Docker"

# 清理所有第三方问题源（Chrome等）
RUN rm -f /etc/apt/sources.list.d/*.list

# 重写干净的Ubuntu旧版归档源，移除不存在的security仓库
RUN echo "deb http://old-releases.ubuntu.com/ubuntu/ focal main restricted universe multiverse" > /etc/apt/sources.list \
    && echo "deb http://old-releases.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://old-releases.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list

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
