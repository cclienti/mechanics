openocd -f interface/cmsis-dap.cfg -f target/rp2040.cfg -c "adapter speed 5000"

minicom -b 115200 -o -D /dev/ttyACM0
