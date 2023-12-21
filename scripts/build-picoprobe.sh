#!/bin/bash

set -e

CPU_COUNT=$(cat /proc/cpuinfo | grep processor | wc -l)
OPENODCD_INSTALL_DIR=${HOME}/rpi-openocd

#############################################
# Build picoprobe firmware
#############################################
git clone https://github.com/raspberrypi/picoprobe.git
pushd picoprobe
git submodule update --init --recursive
mkdir build
cd build
cmake -DPICO_SDK_FETCH_FROM_GIT=1 ..
make -j${CPU_COUNT}
popd

#############################################
# Build the rpi openocd
#############################################
git clone https://github.com/raspberrypi/openocd.git rpi-openocd
pushd rpi-openocd
git checkout rp2040
git submodule update --init --recursive
./bootstrap
./configure --prefix=${HOME}/rpi-openocd
make -j${CPU_COUNT}
make install
popd

#############################################
# Add a startup script
#############################################
mkdir -p ${OPENODCD_INSTALL_DIR}/bin

cat <<EOF >${OPENODCD_INSTALL_DIR}/bin/pico-openocd.sh
#!/bin/bash
${OPENODCD_INSTALL_DIR}/bin/openocd \
        -f ${HOME}/rpi-openocd/share/openocd/scripts/interface/picoprobe.cfg \
        -f ${HOME}/rpi-openocd/share/openocd/scripts/target/rp2040.cfg \
        $*
EOF
chmod u+x ${OPENODCD_INSTALL_DIR}/bin/pico-openocd.sh
echo "You can start openocd by launching the command: ${OPENODCD_INSTALL_DIR}/bin/pico-openocd.sh"
echo "Warning:"
echo "Examine rpi-openocd/contrib/60-openocd.rules to add the picoprobe usb vendor_id/product_id and copy the file to /etc/udev/rules.d/"
echo "Then reboot or reload udev rules with the command 'sudo udevadm control --reload-rules && sudo udevadm trigger'"
echo "Proposed patch:"
echo "# Picoprobe"
echo 'ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="000c", MODE="660", GROUP="plugdev", TAG+="uaccess"'
