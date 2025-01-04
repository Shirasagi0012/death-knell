# death-knell
一个查成绩的脚本，希望接收到的不是噩耗...  
相比原版，加入了对飞书bot Webhook的支持，以及容器化。

## Note

Just for NJUPT.

## How to Use it
```powershell
# 构建镜像
# 在dockerfile所在目录下执行：
docker build -t death-knell .

# 运行容器
docker run -d `
     -e "STUDENT_ID=你的学号" `
     -e "PASSWORD=教务系统密码" `
     -e "NAME=（似乎不填也没事）" `
     -e "WEBHOOK_URL=飞书Bot的Webhook地址，如https://open.feishu.cn/open-apis/bot/v2/hook/****" `
     death-knell
```

## Credit

 Xunop/death-knell: 原始项目
 Serein203: 飞书bot Webhook支持
