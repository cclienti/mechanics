#!/bin/bash

OPENODCD_INSTALL_DIR=${HOME}/rpi-openocd

${OPENODCD_INSTALL_DIR}/bin/openocd \
    -f ${OPENODCD_INSTALL_DIR}/share/openocd/scripts/interface/cmsis-dap.cfg \
    -f ${OPENODCD_INSTALL_DIR}/share/openocd/scripts/target/rp2040.cfg \
    -s tcl -c "adapter speed 5000"
