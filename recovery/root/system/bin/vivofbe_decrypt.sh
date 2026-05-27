#!/system/bin/sh
#
# Vivo FBE Decryption Script
# Execute this script in TWRP terminal to decrypt data partition
#

echo "==================================="
echo "Vivo FBE Decryption Tool"
echo "==================================="
echo ""

# Check if security services are ready
SERVICES_READY=$(getprop recovery.state.services.ready)
if [ "$SERVICES_READY" != "1" ]; then
    echo "Waiting for security services..."
    COUNT=0
    while [ "$SERVICES_READY" != "1" ] && [ $COUNT -lt 30 ]; do
        sleep 1
        COUNT=$((COUNT + 1))
        SERVICES_READY=$(getprop recovery.state.services.ready)
        echo "Waiting... ($COUNT/30)"
    done
    
    if [ "$SERVICES_READY" != "1" ]; then
        echo "ERROR: Security services not available!"
        exit 1
    fi
fi

echo "Security services ready."
echo ""

# Execute vivofbe
echo "Executing vivofbe..."
/system/bin/vivofbe
RESULT=$?

if [ $RESULT -eq 0 ]; then
    echo ""
    echo "SUCCESS: Decryption completed!"
    echo "You can now mount /data partition."
else
    echo ""
    echo "FAILED: vivofbe returned $RESULT"
    echo "This may indicate:"
    echo "  - Device has lockscreen password/pattern/PIN"
    echo "  - Security services not properly initialized"
    echo "  - Hardware/keymaster issue"
fi

exit $RESULT
