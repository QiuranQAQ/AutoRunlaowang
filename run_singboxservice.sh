#!/bin/bash

# --- 配置 ---
# 用于在 crontab 中唯一标识此任务的注释，方便查找和管理
CRON_JOB_COMMENT="# Auto-runner for sing-box script"

# --- 脚本核心逻辑 ---

# 获取此脚本自身的绝对路径，这对于在 crontab 中正确引用至关重要
# readlink -f 会解析所有符号链接，确保得到最终的真实路径
SCRIPT_PATH=$(readlink -f "$0")

# 定义 crontab 中的定时任务命令
# 格式为：每小时的第0分钟执行此脚本
CRON_JOB="0 * * * * ${SCRIPT_PATH}"

# 函数：设置或验证定时任务
setup_cron_job() {
    # 列出当前的 crontab 内容
    # "crontab -l 2>/dev/null" 会尝试列出内容，如果 crontab 为空导致错误，则将错误信息丢弃
    CURRENT_CRON=$(crontab -l 2>/dev/null)
    
    # 检查我们的定时任务注释是否已经存在于 crontab 中
    if echo "${CURRENT_CRON}" | grep -qF "${CRON_JOB_COMMENT}"; then
        echo "定时任务已存在，无需操作。"
    else
        echo "未找到定时任务，正在为您创建..."
        # 将现有的 crontab 内容和我们的新任务组合起来，然后写入 crontab
        # 这种方式可以安全地添加任务，而不会覆盖掉您可能已有的其他定时任务
        (echo "${CURRENT_CRON}"; echo "${CRON_JOB} ${CRON_JOB_COMMENT}") | crontab -
        
        if [ $? -eq 0 ]; then
            echo "定时任务创建成功！脚本将从下个小时开始自动运行。"
        else
            echo "错误：创建定时任务失败。请检查您的系统权限。"
            exit 1
        fi
    fi
}

# 函数：执行主要的核心任务
perform_main_task() {
    echo "正在执行核心任务..."
    # 这里是您原来的命令
    echo -e "3\n3\n\n0" | bash <(curl -Ls https://raw.githubusercontent.com/eooce/sing-box/main/sing-box.sh)
    echo "核心任务执行完毕。"
}

# --- 脚本执行入口 ---

# 1. 首先，确保定时任务已经设置好
setup_cron_job

# 2. 然后，执行本次的核心任务
perform_main_task

exit 0

