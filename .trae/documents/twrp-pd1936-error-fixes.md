# TWRP PD1936 Recovery 错误修复计划

## 错误清单

根据 `recovery.log` 分析，共发现以下错误，按严重程度排序：

### 🔴 严重错误（影响核心功能）

| # | 错误 | 日志证据 | 影响 |
|---|------|----------|------|
| 1 | **MTP 驱动无法打开** | `E:[MTP] could not open MTP driver, errno: 2` | 无法通过 MTP 在电脑端传输文件 |
| 2 | **persist 分区挂载检查持续失败** | `Is_Mounted: Unable to find partition for path '/mnt/vendor/persist'`（数百次） | 日志刷屏，persist 分区无法被 TWRP 正确管理 |
| 3 | **VGC 分区挂载失败** | `Can't probe device /dev/block/sda10` / `Failed to mount '/vgc' (Invalid argument)` | VGC 分区不可用 |
| 4 | **qseecomd 服务持续重启** | `init.svc.qseecomd=restarting` | 可能影响解密稳定性 |

### 🟡 中等错误（影响部分功能）

| # | 错误 | 日志证据 | 影响 |
|---|------|----------|------|
| 5 | **振动器节点缺失** | `Cannot find file /sys/class/timed_output/vibrator/enable`（多次） | 无触觉反馈 |
| 6 | **USB 存储模式不可用** | `Lun file '/sys/class/android_usb/android0/f_mass_storage/lun0/file' does not exist` | USB 大容量存储模式禁用 |
| 7 | **misc 分区未找到** | `failed to find /misc partition` | 可能影响 OTA 更新检测 |

### 🟢 轻微错误（不影响核心使用）

| # | 错误 | 日志证据 | 影响 |
|---|------|----------|------|
| 8 | **自定义主题加载失败** | `Failed to load package '/data/media/0/TWRP/theme/ui.zip'` | 回退到默认主题 |
| 9 | **图片资源加载失败** | `Failed to load image from indeterminate013, error -1` | 进度条动画缺失 |
| 10 | **fscrypt 初始化警告** | `fscrypt_initialize_systemwide_keys returned fail`（3次） | 警告，但解密最终成功 |
| 11 | **recovery.log chmod 失败** | `E:Unable to chmod file: /data/media/0/recovery.log. Error: No such file or directory` | 日志复制时的权限问题 |

---

## 修复方案

### 修复 1: MTP 驱动无法打开

**根因分析**：
- `BoardConfig.mk` 中设置了 `TW_MTP_DEVICE := /dev/mtp_usb`，但该设备节点在 configfs USB 配置下不存在
- `init.recovery.usb.rc` 中混合使用了旧版 `android_usb` sysfs 接口（`/sys/class/android_usb/android0/`）和 configfs，但该设备只支持 configfs
- 日志中 `Cannot find file /sys/class/android_usb/android0/idVendor` 和 `Cannot find file /sys/class/android_usb/android0/idProduct` 证实旧接口不可用

**修复步骤**：
1. 修改 `BoardConfig.mk`：移除 `TW_MTP_DEVICE := /dev/mtp_usb`，改用 configfs 自动检测
2. 修改 `init.recovery.usb.rc`：移除所有对 `/sys/class/android_usb/android0/` 的引用，统一使用 configfs 配置

### 修复 2: persist 分区挂载检查持续失败

**根因分析**：
- `init.recovery.qcom.rc` 的 `on fs` 阶段尝试挂载 persist 分区
- 但 TWRP 的分区管理器在 UI 刷新时反复调用 `Is_Mounted` 检查，而 persist 分区在 TWRP 启动流程中可能未被正确挂载
- `init.recovery.svc.rc` 中创建了 `/mnt/vendor/persist` 目录但没有确保挂载成功

**修复步骤**：
1. 修改 `recovery.fstab`：为 persist 分区添加 `flags=display="Persist";backup=1;canbeencrypted=0` 并移除可能导致问题的挂载参数
2. 修改 `init.recovery.qcom.rc`：在挂载 persist 之前添加 `wait` 确保设备节点就绪，并添加挂载失败时的容错处理
3. 修改 `init.recovery.svc.rc`：确保 persist 挂载点目录权限正确

### 修复 3: VGC 分区挂载失败

**根因分析**：
- `/dev/block/sda10` 无法被 probe，可能是该分区使用了 vivo 专有格式或已加密
- fstab 中标记为 `ro,barrier=1,discard` 但实际文件系统可能不是标准 ext4

**修复步骤**：
1. 修改 `recovery.fstab`：将 VGC 分区标记为不可挂载，添加 `flags=display="VGC";backup=1;canflashimg` 并移除自动挂载标志
2. 或者直接从 fstab 中移除 VGC 条目（该分区对 recovery 操作无实际用途）

### 修复 4: qseecomd 服务持续重启

**根因分析**：
- `init.recovery.platform.rc` 中 `on early-boot` 启动 qseecomd，但可能缺少必要的依赖或设备节点
- qseecomd 需要 `/dev/qseecom` 设备节点和正确的 SELinux 上下文

**修复步骤**：
1. 修改 `init.recovery.platform.rc`：为 qseecomd 服务添加 `onrestart` 延迟和重试限制
2. 确保 `/dev/qseecom` 权限在 `init.recovery.qcom.rc` 中已正确设置（已有 `chmod 0666 /dev/qseecom`）

### 修复 5: 振动器节点缺失

**根因分析**：
- TWRP 默认查找 `/sys/class/timed_output/vibrator/enable`，但高通 msmnile 平台使用不同的 vibrator 路径
- `device.mk` 中已包含 `android.hardware.vibrator@1.0-impl`，但缺少对应的 init.rc 配置

**修复步骤**：
1. 修改 `BoardConfig.mk`：添加 `TW_NO_VIBRATION := true` 禁用振动功能（最简单的方案）
2. 或者在 `init.recovery.touch.rc` 中添加 vibrator HAL 服务的启动配置

### 修复 6: USB 存储模式不可用

**根因分析**：
- TWRP 尝试使用旧版 USB mass storage sysfs 接口，但 configfs 设备不支持
- 这是 configfs USB 架构的已知限制，MTP 是推荐的替代方案

**修复步骤**：
1. 修改 `BoardConfig.mk`：添加 `TW_HAS_NO_USB_STORAGE := true` 明确禁用 USB 存储模式
2. 这将消除启动时的警告信息

### 修复 7: misc 分区未找到

**根因分析**：
- fstab 中定义了 `/misc` 分区但使用 `emmc` 类型，TWRP 在某些情况下无法正确识别
- 日志显示 `failed to find /misc partition`

**修复步骤**：
1. 修改 `recovery.fstab`：确认 misc 分区的 block device 路径正确，添加必要的 flags

### 修复 8: fscrypt 初始化警告

**根因分析**：
- `fscrypt_initialize_systemwide_keys` 返回失败，但数据分区最终成功解密
- 这是因为 vivo 的 FBE 实现使用自定义的 vivofbe 解密流程，而非标准 fscrypt

**修复步骤**：
1. 这属于预期行为，vivo 设备使用 vivofbe 而非标准 fscrypt，警告可忽略
2. 无需修改

### 修复 9: 自定义主题/图片加载失败

**根因分析**：
- `/data/media/0/TWRP/theme/ui.zip` 不存在（首次使用 TWRP）
- `indeterminate013` 图片资源缺失是 TWRP 3.7.0 的已知 bug

**修复步骤**：
1. 自定义主题不存在是正常的（用户未安装自定义主题）
2. `indeterminate013` 图片缺失是 TWRP 上游 bug，无法在设备树层面修复
3. 无需修改

### 修复 10: recovery.log chmod 失败

**根因分析**：
- 日志导出时尝试 chmod 一个尚未成功复制的文件
- 这是 TWRP 日志复制功能的时序问题

**修复步骤**：
1. 这是 TWRP 核心代码的问题，无法在设备树层面修复
2. 日志最终还是成功导出了，影响极小
3. 无需修改

---

## 实施步骤（按优先级）

1. **修改 `BoardConfig.mk`** — 添加 `TW_NO_VIBRATION := true`、`TW_HAS_NO_USB_STORAGE := true`，移除 `TW_MTP_DEVICE`
2. **修改 `recovery.fstab`** — 修复 persist 分区 flags，处理 VGC 分区，确认 misc 分区配置
3. **修改 `init.recovery.usb.rc`** — 移除旧版 android_usb sysfs 引用，统一使用 configfs
4. **修改 `init.recovery.qcom.rc`** — 增强 persist 分区挂载的容错处理
5. **修改 `init.recovery.platform.rc`** — 为 qseecomd 添加重启限制
6. **重新编译 TWRP 并测试验证**
