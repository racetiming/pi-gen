#!/bin/bash -e

rm -f "${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d/wait.conf"

# firstboot
install -v -m 644 files/firstboot.service ${ROOTFS_DIR}/lib/systemd/system/firstboot.service
$(cd ${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants && ln -s /lib/systemd/system/firstboot.service .)

# make our user sudo-able, probably not necessary, just convenient
echo "${FIRST_USER_NAME} ALL=(ALL) NOPASSWD: ALL" > "${ROOTFS_DIR}/etc/sudoers.d/010_${FIRST_USER_NAME}-nopasswd"

