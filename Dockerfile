# 官方Ubuntu22.04，长期支持，软件源永久稳定可用
FROM ubuntu:22.04

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 更换国内阿里云源，国内构建极速不404
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list

# 安装LXDE桌面、noVNC、浏览器、运行依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    lxde-core \
    novnc \
    x11vnc \
    wget \
    libnss3 \
    libatk-bridge2.0-0 \
    libdrm2 \
    libxkbcommon0 \
    libgbm1 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

# 下载安装洛雪音乐v2.12.2，带重试防下载失败
RUN wget --tries=3 --timeout=30 -O /tmp/lx-music.deb \
    "https://github.com/lyswhut/lx-music-desktop/releases/download/v2.12.2/lx-music-desktop_2.12.2_amd64.deb" \
    && dpkg -i /tmp/lx-music.deb || apt-get install -f -y \
    && rm /tmp/lx-music.deb

# 配置VNC
RUN mkdir -p /root/.vnc \
    && x11vnc -storepasswd 123456 /root/.vnc/passwd

# 开机自启洛雪音乐
RUN echo "lx-music-desktop --no-sandbox &" >> /root/.config/lxsession/LXDE/autostart

# 开放网页访问端口
EXPOSE 6080

# 启动脚本：启动桌面+VNC+noVNC网页
CMD ["sh","-c","x11vnc -forever -usepw -create -display :0 & /usr/share/novnc/utils/launch.sh --vnc localhost:5900 --listen 6080"]
