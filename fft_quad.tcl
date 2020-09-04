# FFT quad
set ip_name "fft_quad"
create_project $ip_name . -force
source ./util.tcl

# file
set proj_fileset [get_filesets sources_1]
add_files -norecurse -scan_for_includes -fileset $proj_fileset [list \
"fft_quad.v" \
]

set_property "top" "fft_quad" $proj_fileset

ipx::package_project -root_dir . -vendor kuhep -library user -taxonomy /kuhep
set_property name $ip_name [ipx::current_core]
set_property vendor_display_name {kuhep} [ipx::current_core]


create_ip -vlnv [latest_ip xfft] -module_name xfft_0
set_property CONFIG.transform_length 16384 [get_ips xfft_0]
set_property CONFIG.input_width 14 [get_ips xfft_0]
set_property CONFIG.phase_factor_width 16 [get_ips xfft_0]
set_property CONFIG.scaling_options "unscaled" [get_ips xfft_0]
set_property CONFIG.rounding_modes "convergent_rounding" [get_ips xfft_0]
set_property CONFIG.target_clock_frequency 300 [get_ips xfft_0]
set_property CONFIG.target_data_throughput 300 [get_ips xfft_0]
set_property CONFIG.xk_index true [get_ips xfft_0]

# ?
#set_property CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors 7 [get_ips xfft_0]

# CORDIC
create_ip -vlnv [latest_ip cordic] -module_name cordic_0
set_property CONFIG.Input_Width 29 [get_ips cordic_0]
set_property CONFIG.Output_Width 29 [get_ips cordic_0]
set_property CONFIG.Phase_Format Scaled_Radians [get_ips cordic_0]
set_property CONFIG.Compensation_Scaling LUT_based [get_ips cordic_0]
set_property CONFIG.Round_Mode Nearest_Even [get_ips cordic_0]

# FIFO for index
create_ip -vlnv [latest_ip axis_data_fifo] -module_name axis_data_fifo_0
set_property -dict [list CONFIG.TDATA_NUM_BYTES {2} CONFIG.FIFO_DEPTH {128}] [get_ips axis_data_fifo_0]

# Addsub
create_ip -vlnv [latest_ip c_addsub] -module_name c_addsub_fft_quad
set_property -dict [list \
    CONFIG.A_Width {32} CONFIG.B_Width {32} \
    CONFIG.Latency_Configuration {Manual} \
    CONFIG.CE {false} \
    CONFIG.Out_Width {32} \
    CONFIG.Latency {3} \
] [get_ips c_addsub_fft_quad]


# file groups
ipx::add_file ./fft_quad.srcs/sources_1/ip/xfft_0/xfft_0.xci \
[ipx::get_file_groups xilinx_anylanguagesynthesis -of_objects [ipx::current_core]]
ipx::add_file ./fft_quad.srcs/sources_1/ip/axis_data_fifo_0/axis_data_fifo_0.xci \
[ipx::get_file_groups xilinx_anylanguagesynthesis -of_objects [ipx::current_core]]
ipx::add_file ./fft_quad.srcs/sources_1/ip/cordic_0/cordic_0.xci \
[ipx::get_file_groups xilinx_anylanguagesynthesis -of_objects [ipx::current_core]]
ipx::reorder_files -after ./fft_quad.srcs/sources_1/ip/cordic_0/cordic_0.xci \
fft_quad.v [ipx::get_file_groups xilinx_anylanguagesynthesis -of_objects [ipx::current_core]]


# Interface
ipx::infer_bus_interface clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::save_core [ipx::current_core]
