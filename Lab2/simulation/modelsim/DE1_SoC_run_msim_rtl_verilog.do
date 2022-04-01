transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/suhey/OneDrive/Desktop/College\ Knowledge/2022\ WI/EE\ 371/Labs/Lab2 {C:/Users/suhey/OneDrive/Desktop/College Knowledge/2022 WI/EE 371/Labs/Lab2/ram32x4.v}
vlog -sv -work work +incdir+C:/Users/suhey/OneDrive/Desktop/College\ Knowledge/2022\ WI/EE\ 371/Labs/Lab2 {C:/Users/suhey/OneDrive/Desktop/College Knowledge/2022 WI/EE 371/Labs/Lab2/display_hex_value.sv}
vlog -sv -work work +incdir+C:/Users/suhey/OneDrive/Desktop/College\ Knowledge/2022\ WI/EE\ 371/Labs/Lab2 {C:/Users/suhey/OneDrive/Desktop/College Knowledge/2022 WI/EE 371/Labs/Lab2/ram_implementation.sv}

