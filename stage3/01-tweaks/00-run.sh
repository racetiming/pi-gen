#!/bin/bash -e

rm -f "${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d/wait.conf"

# firstboot
install -v -m 644 files/firstboot.service ${ROOTFS_DIR}/lib/systemd/system/firstboot.service
$(cd ${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants && ln -s /lib/systemd/system/firstboot.service .)

# create an autostart file that runs chromium and points to our kiosk url
sed "s|RACETIMING_KIOSK_URL|$RACETIMING_KIOSK_URL|" < files/autostart > /tmp/autostart
install -v -d ${ROOTFS_DIR}/etc/xdg/lxsession/LXDE-pi/
install -v -m 644 /tmp/autostart ${ROOTFS_DIR}/etc/xdg/lxsession/LXDE-pi/
rm /tmp/autostart

# not sure if this is necessary, but putting the wpa_supplicant.conf file in /boot
# overcomes rkfill
install -v -m 644 ${ROOTFS_DIR}/etc/wpa_supplicant/wpa_supplicant.conf ${ROOTFS_DIR}/boot

# make our user sudo-able, probably not necessary, just convenient
echo "${FIRST_USER_NAME} ALL=(ALL) NOPASSWD: ALL" > "${ROOTFS_DIR}/etc/sudoers.d/010_${FIRST_USER_NAME}-nopasswd"

# autologin - normally this is in stage 4 but bare-bones kiosk mode doesn't go that far
on_chroot << EOF
	SUDO_USER="${FIRST_USER_NAME}" raspi-config nonint do_boot_behaviour B4
EOF
