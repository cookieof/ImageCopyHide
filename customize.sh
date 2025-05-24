#!/system/bin/sh

# 设置模块文件权限
MODDIR=${0%/*}

# 设置脚本可执行权限
chmod 755 "$MODDIR/post-fs-data.sh"
chmod 755 "$MODDIR/service.sh"
chmod 755 "$MODDIR/customize.sh"

# 创建系统目录
mkdir -p "$MODDIR/system/bin"