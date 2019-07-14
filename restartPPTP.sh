#!/usr/bin/bash

# 写死uuid
PPTPUUID=b7c4f44d-0ea2-4f1e-a3ae-66399c444d7d

# 逻辑判断，如果未连接，则建立连接，否则先断开再连接
if  [[ "$(nmcli con show --active|grep $PPTPUUID)" == "" ]]; then
    nmcli con up uuid $PPTPUUID
else
    nmcli con down uuid $PPTPUUID && nmcli con up uuid $PPTPUUID
fi
