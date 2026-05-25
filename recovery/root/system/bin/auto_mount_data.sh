#!/system/bin/sh
# Auto mount data partition after crypto services are ready

# Wait for crypto services
sleep 2

# Try to mount data partition
mount /data

# If mount fails, try to decrypt first
if [ $? -ne 0 ]; then
    # Trigger data partition setup
    /system/bin/setupfs /data
    mount /data
fi

# Create necessary directories
mkdir -p /data/media/0
mkdir -p /data/adb

# Set permissions
chmod 755 /data/media/0
chmod 700 /data/adb
