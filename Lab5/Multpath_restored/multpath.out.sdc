## Generated SDC file "multpath.out.sdc"

## Copyright (C) 2017  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Intel and sold by Intel or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 17.0.0 Build 595 04/25/2017 SJ Lite Edition"

## DATE    "Fri Mar 04 23:17:10 2022"

##
## DEVICE  "5CGXFC7C7F23C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clock_333} -period 3.000 -waveform { 0.000 1.500 } [get_ports { clock_333 }]
create_clock -name {clock_666} -period 1.500 -waveform { 0.000 0.750 } [get_ports { clock_666 }]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {clock_333}] -rise_to [get_clocks {clock_666}]  0.100  
set_clock_uncertainty -rise_from [get_clocks {clock_333}] -fall_to [get_clocks {clock_666}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {clock_333}] -rise_to [get_clocks {clock_666}]  0.100  
set_clock_uncertainty -fall_from [get_clocks {clock_333}] -fall_to [get_clocks {clock_666}]  0.100  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************

set_multicycle_path -setup -end -from  [get_clocks {clock_333}]  -to  [get_clocks {clock_666}] 2
set_multicycle_path -hold -end -from  [get_clocks {clock_333}]  -to  [get_clocks {clock_666}] 1


#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

