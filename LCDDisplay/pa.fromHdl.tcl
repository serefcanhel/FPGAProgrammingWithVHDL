
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name LCDDisplay -dir "C:/Users/Serefcan/Desktop/Seref/FPGA_Codes/LCDDisplay/planAhead_run_5" -part xc3s500efg320-4
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "LCD.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {LCD.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top LCD $srcset
add_files [list {LCD.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc3s500efg320-4
