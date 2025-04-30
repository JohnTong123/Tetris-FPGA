# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\Users\johna\Tetris-FPGA\oof\sob\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\Users\johna\Tetris-FPGA\oof\sob\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {sob}\
-hw {C:\Users\johna\Tetris-FPGA\tetris\sob.xsa}\
-out {C:/Users/johna/Tetris-FPGA/oof}

platform write
domain create -name {standalone_microblaze_0} -display-name {standalone_microblaze_0} -os {standalone} -proc {microblaze_0} -runtime {cpp} -arch {32-bit} -support-app {hello_world}
platform generate -domains 
platform active {sob}
platform generate -quick
platform generate
