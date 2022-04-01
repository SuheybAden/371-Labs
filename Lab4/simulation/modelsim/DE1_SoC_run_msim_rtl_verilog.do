transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/suhey/OneDrive/Desktop/College\ Knowledge/2022\ WI/EE\ 371/Labs/Lab4 {C:/Users/suhey/OneDrive/Desktop/College Knowledge/2022 WI/EE 371/Labs/Lab4/DE1_SoC.sv}
vlog -sv -work work +incdir+C:/Users/suhey/OneDrive/Desktop/College\ Knowledge/2022\ WI/EE\ 371/Labs/Lab4 {C:/Users/suhey/OneDrive/Desktop/College Knowledge/2022 WI/EE 371/Labs/Lab4/bit_counter.sv}
vlog -sv -work work +incdir+C:/Users/suhey/OneDrive/Desktop/College\ Knowledge/2022\ WI/EE\ 371/Labs/Lab4 {C:/Users/suhey/OneDrive/Desktop/College Knowledge/2022 WI/EE 371/Labs/Lab4/display_hex_value.sv}

