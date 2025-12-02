# TWRP 触摸屏功能配置说明

## 设备触摸屏概述

PD1936 (vivo V1936A) 设备使用的是 FocalTech 触摸屏控制器 (fts/fts_i2c)，并且具有以下特点：

1. 主触摸屏控制器：`/sys/devices/virtual/fts/fts_i2c/`
2. 第二触摸屏控制器：`/sys/devices/virtual/fts-second/fts_i2c_second/`
3. vivo 专有的虚拟触摸屏类：`/sys/class/vts/vivo_ts/`

## 触摸屏初始化配置

在 [init.recovery.touch.rc](file:///F:/新建文件夹/PD1936/recovery/root/init.recovery.touch.rc) 文件中，系统做了以下配置：

### 权限设置
- 为各种触摸屏相关 sysfs 节点设置适当的用户和组权限
- 为 `/dev/gtp_tools` 字符设备设置权限
- 为 NVTSPI 相关 proc 节点设置权限

### vivo 专有触摸屏接口
系统配置了大量 vivo 特有的触摸屏接口节点，包括：
- 固件更新接口：`firmware`, `firmware_mp`, `firmware_config`
- 传感器测试接口：`sensor_test`, `sensor_caliberate`
- 手势识别：`gesture_points`
- 显示相关：`touch_area`, `version`
- 状态监控：`status/*`

### 触摸屏更新服务
配置了一个名为 `touchupdate` 的服务，它会执行：
```
service touchupdate /system/bin/vts_app_recovery --update
```

## TWRP 触摸屏配置优化

在 BoardConfig.mk 中，我们增加了以下与触摸屏相关的配置：

### 输入设备黑名单
[TW_INPUT_BLACKLIST](file:///F:/新建文件夹/PD1936/out/../../.././device/vivo/PD1936/BoardConfig.mk#L102-L102) := "hbtp_vm"
- 黑名单 "hbtp_vm" 设备，避免与 TWRP 的输入处理冲突

### 新增触摸屏功能支持
1. [TW_TOUCHSCREEN_PEN](file:///F:/新建文件夹/PD1936/out/../../.././device/vivo/PD1936/BoardConfig.mk#L117-L117) := true
   - 启用手写笔支持
   
2. [TW_SUPPORT_INPUT_AIDL_EVDEV](file:///F:/新建文件夹/PD1936/out/../../.././device/vivo/PD1936/BoardConfig.mk#L118-L118) := true
   - 支持新的 AIDL evdev 输入接口

## 触摸屏固件

设备包含多个触摸屏固件文件，位于 [/vendor/firmware/](file:///F:/新建文件夹/PD1936/recovery/root/vendor/firmware/) 目录中：
- TP 配置固件：不同 LCM ID 和版本的配置文件
- TP 主固件：实际的触摸屏固件
- 专为恢复模式准备的固件：[touch_firmwares_recovery.bin](file:///F:/新建文件夹/PD1936/recovery/root/vendor/firmware/touch_firmwares_recovery.bin)

## 调试和故障排除

### 相关 sysfs 节点
可以通过以下节点调试触摸屏功能：
- `/sys/class/vts/vivo_ts/sensor_test` - 传感器测试
- `/sys/class/vts/vivo_ts/firmware` - 固件信息查询
- `/sys/class/vts/vivo_ts/gesture_points` - 手势坐标信息
- `/sys/class/vts/vivo_ts/status/` - 各种状态信息

### 日志调试
可以使用以下方法获取触摸屏相关日志：
1. 在 recovery 中使用 `logcat` 命令
2. 检查 `dmesg` 输出中的触摸屏相关消息
3. 查看 `/sys/class/vts/vivo_ts/ts_log_switch` 是否启用日志

## 注意事项

1. vivo 的专有触摸屏实现可能与标准 AOSP 实现有差异
2. 恢复模式下需要特殊固件 [touch_firmwares_recovery.bin](file:///F:/新建文件夹/PD1936/recovery/root/vendor/firmware/touch_firmwares_recovery.bin) 来保证触摸功能正常工作
3. [vts_app_recovery](file:///F:/新建文件夹/PD1936/recovery/root/system/bin/vts_app_recovery) 服务负责在恢复模式下更新触摸屏固件
4. TWRP 需要正确配置输入设备黑名单以避免冲突