transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Github/Microprocessor-EE337/Project-2/VHDL Files/components.vhd}
vcom -93 -work work {C:/Github/Microprocessor-EE337/Project-2/VHDL Files/comp2.vhd}

