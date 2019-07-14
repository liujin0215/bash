#!/usr/bin/bash

# 停止tv服务
teamviewer --daemon stop

# 删除tv配置
rm -rf /etc/teamviewer/global.conf

# 重置mac地址
macchanger -r enp0s31f6

# 启动tv服务
teamviewer --daemon start
