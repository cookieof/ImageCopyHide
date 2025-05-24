#!/system/bin/sh

# 检查是否开机
while true; do
    if [ -d "/storage/emulated/0/Android/data" ]; then
        break
    fi
sleep 2
done

# 初始化目录和配置文件
MODDIR=${0%/*}
WOT_DIR="/sdcard/wot"
CPTP_DIR="$WOT_DIR/cptp"
CONFIG_FILE="$WOT_DIR/cptp_config"
LOG_DIR="$WOT_DIR/TP"

# 创建wot目录
if [ ! -d "$WOT_DIR" ]; then
    mkdir -p "$WOT_DIR"
    chmod 777 "$WOT_DIR"
fi

# 创建cptp目录
if [ ! -d "$CPTP_DIR" ]; then
    mkdir -p "$CPTP_DIR"
    chmod 777 "$CPTP_DIR"
fi

# 创建日志目录
if [ ! -d "$LOG_DIR" ]; then
    mkdir -p "$LOG_DIR"
    chmod 777 "$LOG_DIR"
fi

# 创建默认配置文件
if [ ! -f "$CONFIG_FILE" ]; then
    echo "ENABLED=1" > "$CONFIG_FILE"
    echo "INTERVAL=45" >> "$CONFIG_FILE"
    chmod 666 "$CONFIG_FILE"
fi

# 模块工作目录
MODDIR=${0%/*}
WOT_DIR="/sdcard/wot"
CPTP_DIR="$WOT_DIR/cptp"
CONFIG_FILE="$WOT_DIR/cptp_config"
LOG_FILE="$WOT_DIR/TP/autocopy.log"
SOURCE_DIR="/sdcard/DCIM/Camera"

# 初始化上次检查时间
LAST_CHECK=0

# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# 读取配置
read_config() {
    if [ -f "$CONFIG_FILE" ]; then
        . "$CONFIG_FILE"
    else
        ENABLED=1
        INTERVAL=45
    fi
}

# 复制并隐藏文件
copy_and_hide() {
    for file in "$1"/*; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            if [ ! -f "$CPTP_DIR/.$filename" ]; then
                cp "$file" "$CPTP_DIR/.$filename"
                chmod 666 "$CPTP_DIR/.$filename"
                log "Copied and hidden: $filename"
            fi
        fi
    done
}

# 主循环
while true; do
    read_config
    
    if [ "$ENABLED" -eq 1 ]; then
        current_time=$(date +%s)
        if [ $((current_time - LAST_CHECK)) -ge $INTERVAL ]; then
            copy_and_hide "$SOURCE_DIR"
            LAST_CHECK=$current_time
        fi
    fi
    
    sleep 1
done