transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/home/imkhilji/Desktop/Microprocessor-EE337/Project-2/vhdl_files/d_memory.vhd}

