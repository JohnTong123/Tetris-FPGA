# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\Users\johna\Tetris-FPGA\w\dub\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\Users\johna\Tetris-FPGA\w\dub\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {dub}\
-hw {C:\Users\johna\Tetris-FPGA\tetris\dub.xsa}\
-out {C:/Users/johna/Tetris-FPGA/w}

platform write
domain create -name {standalone_microblaze_0} -display-name {standalone_microblaze_0} -os {standalone} -proc {microblaze_0} -runtime {cpp} -arch {32-bit} -support-app {hello_world}
platform generate -domains 
platform active {dub}
platform generate -quick
platform generate
