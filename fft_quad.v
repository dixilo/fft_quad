`timescale 1ps / 1ps

module fft_quad#(
    parameter INPUT_WIDTH = 14
)(
    input [31 - (16 - INPUT_WIDTH):0] data_in_0,
    input [31 - (16 - INPUT_WIDTH):0] data_in_1,
    input [31 - (16 - INPUT_WIDTH):0] data_in_2,
    input [31 - (16 - INPUT_WIDTH):0] data_in_3,

    input clk,
    input resetn,
    input s_valid,
    
    output [63:0] data_out_0,
    output [63:0] data_out_1,
    output [63:0] data_out_2,
    output [63:0] data_out_3,
    output [13:0] k,
    output m_valid
    
    //DEBUG
//    input         dbg_tlast,
//    input         dbg_tready,
    
//    output [28:0] dbg_ph_0,
//    output [28:0] dbg_ph_1,
//    output [28:0] dbg_ph_2,
//    output [28:0] dbg_ph_3,
    
//    output [63:0] dbg_fft_0,
//    output [63:0] dbg_fft_1,
//    output [63:0] dbg_fft_2,
//    output [63:0] dbg_fft_3,

//    output [63:0] dbg_cord_0,
//    output [63:0] dbg_cord_1,
//    output [63:0] dbg_cord_2,
//    output [63:0] dbg_cord_3,

//    output dbg_ready_0,
//    output dbg_ready_1,
//    output dbg_valid_rot_0,
//    output dbg_valid_rot_1,
//    output dbg_valid_fft_0,
//    output dbg_valid_fft_1,
//    output [13:0] dbg_k0,
//    output [13:0] dbg_k1,
//    output dbg_k_fifo_valid
);
    
    wire [63:0] fft_data_0;
    wire [63:0] fft_data_1;
    wire [63:0] fft_data_2;
    wire [63:0] fft_data_3;
    
//    assign dbg_fft_0 = fft_data_0;
//    assign dbg_fft_1 = fft_data_1;
//    assign dbg_fft_2 = fft_data_2;
//    assign dbg_fft_3 = fft_data_3;
    
    wire [63:0] fft_rot_0;
    wire [63:0] fft_rot_1;
    wire [63:0] fft_rot_2;
    wire [63:0] fft_rot_3;
    
    wire [28:0] phase_0;
    wire [28:0] phase_1;
    wire [28:0] phase_2;
    wire [28:0] phase_3;
    wire [28:0] phase_3_mod;

    wire [13:0] k_0;
    wire [13:0] k_1;
    wire [13:0] k_2;
    wire [13:0] k_3;
    
//    assign dbg_k0 = k_0;
//    assign dbg_k1 = k_1;

    wire valid_fft_0;
    wire valid_fft_1;
    wire valid_fft_2;
    wire valid_fft_3;
    
//    assign dbg_valid_fft_0 = valid_fft_0;
//    assign dbg_valid_fft_1 = valid_fft_1;

    wire valid_rot_0;
    wire valid_rot_1;
    wire valid_rot_2;
    wire valid_rot_3;
    
//    assign dbg_valid_rot_0 = valid_rot_0;
//    assign dbg_valid_rot_1 = valid_rot_1;
    
    wire ready_0;
    wire ready_1;
    wire ready_2;
    wire ready_3;
    
//    assign dbg_ready_0 = ready_0;
//    assign dbg_ready_1 = ready_1;
    
    wire last_0;
    wire last_1;
    wire last_2;
    wire last_3;

    
    // FFT
    xfft_0 fft_0 (
        .aclk(clk),                    // input wire aclk
        .s_axis_config_tdata(16'b0),        // input wire [15 : 0] s_axis_config_tdata
        .s_axis_config_tvalid(1'b0),  // input wire s_axis_config_tvalid
        .s_axis_config_tready(),       // output wire s_axis_config_tready
        .s_axis_data_tdata(data_in_0), // input wire [31 : 0] s_axis_data_tdata
        .s_axis_data_tvalid(s_valid),     // input wire s_axis_data_tvalid
        .s_axis_data_tready(ready_0),         // output wire s_axis_data_tready
//        .s_axis_data_tlast(dbg_tlast),          // input wire s_axis_data_tlast
        .m_axis_data_tdata(fft_data_0),// output wire [31 : 0] m_axis_data_tdata
        .m_axis_data_tuser(k_0),       // output wire [15 : 0] m_axis_data_tuser
        .m_axis_data_tvalid(valid_fft_0),  // output wire m_axis_data_tvalid
//        .m_axis_data_tready(dbg_tready),     // input wire m_axis_data_tready
        .m_axis_data_tready(1'b1),    // input wire m_axis_data_tready 
        .m_axis_data_tlast(last_0),    // output wire m_axis_data_tlast
        .event_frame_started(),        // output wire event_frame_started
        .event_tlast_unexpected(),     // output wire event_tlast_unexpected
        .event_tlast_missing(),        // output wire event_tlast_missing
        .event_status_channel_halt(),  // output wire event_status_channel_halt
        .event_data_in_channel_halt(), // output wire event_data_in_channel_halt
        .event_data_out_channel_halt() // output wire event_data_out_channel_halt
    );
    
    xfft_0 fft_1 (
        .aclk(clk),                    // input wire aclk
        .s_axis_config_tdata(16'b0),        // input wire [15 : 0] s_axis_config_tdata
        .s_axis_config_tvalid(1'b0),  // input wire s_axis_config_tvalid
        .s_axis_config_tready(),       // output wire s_axis_config_tready
        .s_axis_data_tdata(data_in_1), // input wire [31 : 0] s_axis_data_tdata
        .s_axis_data_tvalid(s_valid),     // input wire s_axis_data_tvalid
        .s_axis_data_tready(ready_1),         // output wire s_axis_data_tready
//        .s_axis_data_tlast(dbg_tlast),          // input wire s_axis_data_tlast
        .m_axis_data_tdata(fft_data_1),// output wire [31 : 0] m_axis_data_tdata
        .m_axis_data_tuser(k_1),       // output wire [15 : 0] m_axis_data_tuser
        .m_axis_data_tvalid(valid_fft_1),  // output wire m_axis_data_tvalid
        .m_axis_data_tready(1'b1),  // input wire m_axis_data_tready
        .m_axis_data_tlast(last_1),    // output wire m_axis_data_tlast
        .event_frame_started(),        // output wire event_frame_started
        .event_tlast_unexpected(),     // output wire event_tlast_unexpected
        .event_tlast_missing(),        // output wire event_tlast_missing
        .event_status_channel_halt(),  // output wire event_status_channel_halt
        .event_data_in_channel_halt(), // output wire event_data_in_channel_halt
        .event_data_out_channel_halt() // output wire event_data_out_channel_halt
    );
    
    xfft_0 fft_2 (
        .aclk(clk),                    // input wire aclk
        .s_axis_config_tdata(16'b0),        // input wire [15 : 0] s_axis_config_tdata
        .s_axis_config_tvalid(1'b0),  // input wire s_axis_config_tvalid
        .s_axis_config_tready(),       // output wire s_axis_config_tready
        .s_axis_data_tdata(data_in_2), // input wire [31 : 0] s_axis_data_tdata
        .s_axis_data_tvalid(s_valid),     // input wire s_axis_data_tvalid
        .s_axis_data_tready(ready_2),         // output wire s_axis_data_tready
        .s_axis_data_tlast(),          // input wire s_axis_data_tlast
        .m_axis_data_tdata(fft_data_2),// output wire [31 : 0] m_axis_data_tdata
        .m_axis_data_tuser(k_2),       // output wire [15 : 0] m_axis_data_tuser
        .m_axis_data_tvalid(valid_fft_2),  // output wire m_axis_data_tvalid
        .m_axis_data_tready(1'b1),  // input wire m_axis_data_tready
        .m_axis_data_tlast(last_2),    // output wire m_axis_data_tlast
        .event_frame_started(),        // output wire event_frame_started
        .event_tlast_unexpected(),     // output wire event_tlast_unexpected
        .event_tlast_missing(),        // output wire event_tlast_missing
        .event_status_channel_halt(),  // output wire event_status_channel_halt
        .event_data_in_channel_halt(), // output wire event_data_in_channel_halt
        .event_data_out_channel_halt() // output wire event_data_out_channel_halt
    );
    
    xfft_0 fft_3 (
        .aclk(clk),                    // input wire aclk
        .s_axis_config_tdata(16'b0),        // input wire [15 : 0] s_axis_config_tdata
        .s_axis_config_tvalid(1'b0),  // input wire s_axis_config_tvalid
        .s_axis_config_tready(),       // output wire s_axis_config_tready
        .s_axis_data_tdata(data_in_3), // input wire [31 : 0] s_axis_data_tdata
        .s_axis_data_tvalid(s_valid),     // input wire s_axis_data_tvalid
        .s_axis_data_tready(ready_3),         // output wire s_axis_data_tready
        .s_axis_data_tlast(),          // input wire s_axis_data_tlast
        .m_axis_data_tdata(fft_data_3),// output wire [31 : 0] m_axis_data_tdata
        .m_axis_data_tuser(k_3),       // output wire [15 : 0] m_axis_data_tuser
        .m_axis_data_tvalid(valid_fft_3),  // output wire m_axis_data_tvalid
        .m_axis_data_tready(1'b1),  // input wire m_axis_data_tready
        .m_axis_data_tlast(last_3),    // output wire m_axis_data_tlast
        .event_frame_started(),        // output wire event_frame_started
        .event_tlast_unexpected(),     // output wire event_tlast_unexpected
        .event_tlast_missing(),        // output wire event_tlast_missing
        .event_status_channel_halt(),  // output wire event_status_channel_halt
        .event_data_in_channel_halt(), // output wire event_data_in_channel_halt
        .event_data_out_channel_halt() // output wire event_data_out_channel_halt
    );
    
    assign phase_0 = 29'b0;
    assign phase_1 = ~{4'b0, k_1, 11'b0} + 29'b1; // -  1 * pi * i * k/(N/4) 
    assign phase_2 = ~{3'b0, k_2, 12'b0} + 29'b1; // -  2 * pi * i * k/(N/4)
    assign phase_3 = ~{3'b0, k_3, 12'b0} + 29'b1 + ~{4'b0, k_3, 11'b0} + 29'b1; // -  3 * pi * i * k/(N/4)
    assign phase_3_mod = (phase_3[26] == 1'b0) ? {3'b0, phase_3[25:0]} : phase_3;  // range should be -1 to 1   

    axis_data_fifo_0 k_fifo (
      .s_axis_aresetn(resetn),  // input wire s_axis_aresetn
      .s_axis_aclk(clk),        // input wire s_axis_aclk
      .s_axis_tvalid(valid_fft_0),    // input wire s_axis_tvalid
      .s_axis_tready(),    // output wire s_axis_tready
      .s_axis_tdata(k_0),      // input wire [15 : 0] s_axis_tdata
      .m_axis_tvalid(),    // output wire m_axis_tvalid
      .m_axis_tready(valid_rot_0),    // input wire m_axis_tready
      .m_axis_tdata(k)      // output wire [15 : 0] m_axis_tdata    
    ); 

    cordic_0 cord_0 (
        .aclk(clk),                            // input wire aclk
        .s_axis_phase_tvalid(valid_fft_0),     // input wire s_axis_phase_tvalid
        .s_axis_phase_tdata(phase_0),          // input wire [31 : 0] s_axis_phase_tdata
        .s_axis_cartesian_tvalid(valid_fft_0), // input wire s_axis_cartesian_tvalid
        .s_axis_cartesian_tdata(fft_data_0),   // input wire [63 : 0] s_axis_cartesian_tdata
        .m_axis_dout_tvalid(valid_rot_0),      // output wire m_axis_dout_tvalid
        .m_axis_dout_tdata(fft_rot_0)          // output wire [63 : 0] m_axis_dout_tdata
    );    

    cordic_0 cord_1 (
        .aclk(clk),                            // input wire aclk
        .s_axis_phase_tvalid(valid_fft_1),     // input wire s_axis_phase_tvalid
        .s_axis_phase_tdata(phase_1),          // input wire [31 : 0] s_axis_phase_tdata
        .s_axis_cartesian_tvalid(valid_fft_1), // input wire s_axis_cartesian_tvalid
        .s_axis_cartesian_tdata(fft_data_1),   // input wire [63 : 0] s_axis_cartesian_tdata
        .m_axis_dout_tvalid(valid_rot_1),      // output wire m_axis_dout_tvalid
        .m_axis_dout_tdata(fft_rot_1)          // output wire [63 : 0] m_axis_dout_tdata
    );
    
    cordic_0 cord_2 (
        .aclk(clk),                            // input wire aclk
        .s_axis_phase_tvalid(valid_fft_2),     // input wire s_axis_phase_tvalid
        .s_axis_phase_tdata(phase_2),          // input wire [31 : 0] s_axis_phase_tdata
        .s_axis_cartesian_tvalid(valid_fft_2), // input wire s_axis_cartesian_tvalid
        .s_axis_cartesian_tdata(fft_data_2),   // input wire [63 : 0] s_axis_cartesian_tdata
        .m_axis_dout_tvalid(valid_rot_2),      // output wire m_axis_dout_tvalid
        .m_axis_dout_tdata(fft_rot_2)          // output wire [63 : 0] m_axis_dout_tdata
    );
    
    cordic_0 cord_3 (
        .aclk(clk),                            // input wire aclk
        .s_axis_phase_tvalid(valid_fft_3),     // input wire s_axis_phase_tvalid
        .s_axis_phase_tdata(phase_3_mod),      // input wire [31 : 0] s_axis_phase_tdata
        .s_axis_cartesian_tvalid(valid_fft_3), // input wire s_axis_cartesian_tvalid
        .s_axis_cartesian_tdata(fft_data_3),   // input wire [63 : 0] s_axis_cartesian_tdata
        .m_axis_dout_tvalid(valid_rot_3),      // output wire m_axis_dout_tvalid
        .m_axis_dout_tdata(fft_rot_3)          // output wire [63 : 0] m_axis_dout_tdata
    );
    assign m_valid = valid_rot_0;
    // A + B + C + D
    assign data_out_0 = fft_rot_0 + fft_rot_1 + fft_rot_2 + fft_rot_3;
    // A - iB - C + iD 
    assign data_out_1 = fft_rot_0 + {~fft_rot_1[31:0] + 32'b1, fft_rot_1[63:32]} - fft_rot_2 + {fft_rot_3[31:0], ~fft_rot_3[63:32] + 32'b1}; 
    // A - B + C - D
    assign data_out_2 = fft_rot_0 - fft_rot_1 + fft_rot_2 - fft_rot_3;
    // A + iB - C - iD
    assign data_out_3 = fft_rot_0 +  {fft_rot_1[31:0], ~fft_rot_1[63:32] + 32'b1} - fft_rot_2 + {~fft_rot_3[31:0] + 32'b1, fft_rot_3[63:32]};
    
//    assign dbg_ph_0 = phase_0;
//    assign dbg_ph_1 = phase_1;
//    assign dbg_ph_2 = phase_2;
//    assign dbg_ph_3 = phase_3_mod;

//    assign dbg_cord_0 = fft_rot_0;
//    assign dbg_cord_1 = fft_rot_1;
//    assign dbg_cord_2 = fft_rot_2;
//    assign dbg_cord_3 = fft_rot_3;


endmodule