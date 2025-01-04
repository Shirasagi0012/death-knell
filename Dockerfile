# 使用 Arch Linux AUR 作为基础镜像
FROM ghcr.io/archlinux/archlinux:latest

ENV STUDENT_ID=""
ENV PASSWORD=""
ENV NAME=""
ENV SCHOOL_YEAR="2024-2025"
ENV SEMESTER="1"
ENV WEBHOOK_URL=""

VOLUME ["/app/data"]

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
CMD ["/bin/bash", "-c", "echo \"SHELL=/bin/bash\" > /etc/cron.d/death-knell && \
    echo \"STUDENT_ID=\\\"$STUDENT_ID\\\"\" >> /etc/cron.d/death-knell && \
    echo \"PASSWORD=\\\"$PASSWORD\\\"\" >> /etc/cron.d/death-knell && \
    echo \"NAME=\\\"$NAME\\\"\" >> /etc/cron.d/death-knell && \
    echo \"SCHOOL_YEAR=\\\"$SCHOOL_YEAR\\\"\" >> /etc/cron.d/death-knell && \
    echo \"SEMESTER=\\\"$SEMESTER\\\"\" >> /etc/cron.d/death-knell && \
    echo \"WEBHOOK_URL=\\\"$WEBHOOK_URL\\\"\" >> /etc/cron.d/death-knell && \
    echo \"0 * * * * root sh /app/run.sh\" >> /etc/cron.d/death-knell && \
    chmod 0644 /etc/cron.d/death-knell && crond -n -x proc"]
