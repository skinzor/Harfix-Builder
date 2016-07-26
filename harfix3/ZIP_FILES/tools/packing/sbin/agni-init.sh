#!/sbin/busybox sh

AGNi_RESETER_CM="/data/media/0/AGNi_reset_oc-uv_on_boot_failure.zip"

# Now wait for the rom to finish booting up
# (by checking for any android process)
while ! /sbin/busybox pgrep android.process.acore ; do
  /sbin/busybox sleep 1
done

# Configuration app is now installed in /system
# removing any instances of user-installations
INFO="/agni_info"
BBOX="/sbin/busybox"
/sbin/busybox sh /sbin/rootrw
$BBOX pm uninstall hm.agni
$BBOX pm uninstall hm.agni.control.dialog.helper
/sbin/busybox sh /sbin/rootro

# AGNi reseter
### AGNi reset oc-uv on boot failure

if [ ! -f $AGNi_RESETER_CM ] ; then
	cp /res/reseter/AGNi_reset_oc-uv_on_boot_failure.zip $AGNi_RESETER_CM
	chmod 777 $AGNi_RESETER_CM
fi

