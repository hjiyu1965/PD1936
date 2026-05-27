#!/system/bin/sh
#
# Vivo FBE Decryption Helper Script for TWRP
# This script ensures all security services are ready before running vivofbe
#

WAIT_COUNT=0
MAX_WAIT=30

while [ $WAIT_COUNT -lt $MAX_WAIT ]; do
    if getprop recovery.state.services.ready | grep -q "1"; then
        echo "[vivo_decrypt] Security services are ready, starting vivofbe..."
        /system/bin/vivofbe
        EXIT_CODE=$?
        if [ $EXIT_CODE -eq 0 ]; then
            echo "[vivo_decrypt] Decryption successful!"
            setprop twcrypto.decrypt 1
        else
            echo "[vivo_decrypt] Decryption failed with exit code: $EXIT_CODE"
            setprop twcrypto.decrypt -1
        fi
        exit $EXIT_CODE
    fi
    WAIT_COUNT=$((WAIT_COUNT + 1))
    echo "[vivo_decrypt] Waiting for security services... ($WAIT_COUNT/$MAX_WAIT)"
    sleep 1
done

echo "[vivo_decrypt] Timeout waiting for security services!"
setprop twcrypto.decrypt -2
exit 1
