# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: C:\Users\johna\Tetris-FPGA\asdf_system\_ide\scripts\debugger_asdf-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source C:\Users\johna\Tetris-FPGA\asdf_system\_ide\scripts\debugger_asdf-default.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -filter {jtag_cable_name =~ "RealDigital Boo 88710000000BA" && level==0 && jtag_device_ctx=="jsn1-0362f093-0"}
fpga -file C:/Users/johna/Tetris-FPGA/asdf/_ide/bitstream/pls.bit
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
loadhw -hw C:/Users/johna/Tetris-FPGA/pls/export/pls/hw/pls.xsa -regs
configparams mdm-detect-bscan-mask 2
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
rst -system
after 3000
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
dow C:/Users/johna/Tetris-FPGA/asdf/Debug/asdf.elf
targets -set -nocase -filter {name =~ "*microblaze*#0" && bscan=="USER2" }
con
