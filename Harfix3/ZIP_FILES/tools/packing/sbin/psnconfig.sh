#!/sbin/busybox sh

#### configurator

###Mali 400MP GPU threshold
echo "30% 22% 50% 45% 50% 45% 50% 45%" > /sys/class/misc/gpu_control/gpu_clock_control

# enable idle+LPA
echo 2 > /sys/module/cpuidle_exynos4/parameters/enable_mask

# enable Dynamic fsync
echo 1 > /sys/kernel/dyn_fsync/Dyn_fsync_active
echo 1 > /sys/kernel/dyn_fsync/Dyn_fsync_earlysuspend

# setting up swappiness
echo 70 > /proc/sys/vm/swappiness


# ZRAM activator 200 MB
#Zram0
swapoff /dev/block/zram0
echo 1 > /sys/block/zram0/reset
echo 209715200 > /sys/block/zram0/disksize
echo 1 > /sys/block/zram0/initstate
mkswap /dev/block/zram0
swapon -p 2 /dev/block/zram0