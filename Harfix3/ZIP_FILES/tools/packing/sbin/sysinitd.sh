#!/sbin/busybox sh

while ! /sbin/busybox pgrep android.process.acore ; do
  /sbin/busybox sleep 1
done
while ! pgrep com.android ; do
	sleep 1
done
sleep 5
while pgrep bootanimation ; do
	sleep 1
done
while pgrep samsungani ; do
	sleep 1
done
sleep 5
while pgrep dexopt ; do
	sleep 1
done
while pgrep dex2oat ; do
	sleep 1
done

# Play sound for Boeffla-Sound compatibility
/sbin/tinyplay /res/misc/silence.wav -D 0 -d 0 -p 880

## Set optimum permissions for init.d scripts
/sbin/busybox sh /sbin/sysrw
/sbin/busybox sh /sbin/rootrw

/sbin/busybox chmod -R 777 /system/etc/init.d

## Setting profiles scripts as non-executable
/sbin/busybox chmod 0666 /system/etc/init.d/S46enable_001bkprofiles_*
/sbin/busybox rm /system/etc/init.d/S35enable_001bkusbumsmode_002-on

# ASV based CPUuv
/sbin/busybox sh /sbin/CPUUV_handler.sh

/sbin/busybox sh /sbin/touchkey_manage.sh

/sbin/busybox sh /sbin/sysro
/sbin/busybox sh /sbin/rootro

#proximity sensor calibration
#echo 0 > /sys/class/sensors/proximity_sensor/prox_cal
#echo 1 > /sys/class/sensors/proximity_sensor/prox_cal

# Execute files in init.d folder
export PATH=/sbin:/system/sbin:/system/bin:/system/xbin
/system/bin/logwrapper /sbin/busybox run-parts /system/etc/init.d

/sbin/busybox sh /sbin/optimise_remounts.sh

