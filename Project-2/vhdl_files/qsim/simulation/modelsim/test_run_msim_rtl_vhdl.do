transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/Om/Desktop/Microprocessor-EE337/Project-2/vhdl_files/components.vhd}
vcom -93 -work work {C:/Users/Om/Desktop/Microprocessor-EE337/Project-2/vhdl_files/nstalls_count.vhd}

