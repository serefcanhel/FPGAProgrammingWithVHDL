
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name Mux2x1 -dir "C:/Users/Serefcan/Desktop/Seref/FPGA_Codes/Mux2x1/planAhead_run_2" -part xc3s500efg320-4
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "mux2x1.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {mux2x1.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top mux2x1 $srcset
add_files [list {mux2x1.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc3s500efg320-4
