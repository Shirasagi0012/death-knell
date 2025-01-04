# 使用 Arch Linux AUR 作为基础镜像
FROM ghcr.io/archlinux/archlinux:latest

ENV STUDENT_ID=""
ENV PASSWORD=""
ENV NAME=""
ENV SCHOOL_YEAR="2024-2025"
ENV SEMESTER="1"
ENV WEBHOOK_URL=""


# 初始化 pacman 密钥并更新系统
RUN pacman-key --init && \
    pacman -Syu --noconfirm

RUN pacman --noconfirm -U https://archive.archlinux.org/packages/p/python/python-3.12.7-1-x86_64.pkg.tar.zst

# 安装所需的软件包
RUN pacman -S --noconfirm firefox geckodriver python-virtualenv bash


# 设置工作目录
WORKDIR /app

# 复制当前目录内容到容器内
COPY . /app

# 移除多余的目录
RUN rm -rf get-score-venv data.db __pycache__

# 创建并激活虚拟环境
RUN python3.12 -m venv get-score-venv
ENV PATH="/app/get-score-venv/bin:$PATH"

# 安装 Python 依赖
RUN pip install -r requirements.txt

# 赋予运行脚本执行权限
RUN chmod +x run.sh

# 安装 cronie
RUN pacman -S --noconfirm cronie

# 创建定时任务
RUN echo "0 * * * * /usr/bin/bash /app/run.sh\n" > /etc/cron.d/death-knell && \
    chmod 0644 /etc/cron.d/death-knell

# 启动定时任务
CMD ["sh", "-c", "crond -n -x proc"]