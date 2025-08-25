#!/bin/bash

# 脚本说明：利用老王脚本避免帕斯云sing-box死掉，用于自动化执行sing-box重启服务脚本

echo -e "3\n3\n\n0" | bash <(curl -Ls https://raw.githubusercontent.com/eooce/sing-box/main/sing-box.sh)
