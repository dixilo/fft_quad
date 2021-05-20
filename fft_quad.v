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
    output m_valid,
    output m_last
);
    
    wire [63:0] fft_data_0;
    wire [63:0] fft_data_1;
    wire [63:0] fft_data_2;
    wire [63:0] fft_data_3;

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
    
    wire valid_fft_0;
    wire valid_fft_1;
    wire valid_fft_2;
    wire valid_fft_3;
    
    wire valid_rot_0;
    wire valid_rot_1;
    wire valid_rot_2;
    wire valid_rot_3;
    
    wire ready_0;
    wire ready_1;
    wire ready_2;
    wire ready_3;
        
    wire last_0;
    wire last_1;
    wire last_2;
    wire last_3;

    // FFT
    xfft_0 fft_0 (
        .aclk(clk),
        .s_axis_config_tdata(16'b0),
        .s_axis_config_tvalid(1'b0),
        .s_axis_config_tready(),
        .s_axis_data_tdata(data_in_0),
        .s_axis_data_tvalid(s_valid),
        .s_axis_data_tready(ready_0),
        .s_axis_data_tlast(),
        .m_axis_data_tdata(fft_data_0),
        .m_axis_data_tuser(k_0),
        .m_axis_data_tvalid(valid_fft_0),
        .m_axis_data_tready(1'b1),
        .m_axis_data_tlast(last_0),
        .event_frame_started(),
        .event_tlast_unexpected(),
        .event_tlast_missing(),
        .event_status_channel_halt(),
        .event_data_in_channel_halt(),
        .event_data_out_channel_halt()
    );
    
    xfft_0 fft_1 (
        .aclk(clk),
        .s_axis_config_tdata(16'b0),
        .s_axis_config_tvalid(1'b0),
        .s_axis_config_tready(),
        .s_axis_data_tdata(data_in_1),
        .s_axis_data_tvalid(s_valid),
        .s_axis_data_tready(ready_1),
        .s_axis_data_tlast(),
        .m_axis_data_tdata(fft_data_1),
        .m_axis_data_tuser(k_1),
        .m_axis_data_tvalid(valid_fft_1),
        .m_axis_data_tready(1'b1),
        .m_axis_data_tlast(last_1),
        .event_frame_started(),
        .event_tlast_unexpected(),
        .event_tlast_missing(),
        .event_status_channel_halt(),
        .event_data_in_channel_halt(),
        .event_data_out_channel_halt()
    );
    
    xfft_0 fft_2 (
        .aclk(clk),
        .s_axis_config_tdata(16'b0),
        .s_axis_config_tvalid(1'b0),
        .s_axis_config_tready(),
        .s_axis_data_tdata(data_in_2),
        .s_axis_data_tvalid(s_valid),
        .s_axis_data_tready(ready_2),
        .s_axis_data_tlast(),
        .m_axis_data_tdata(fft_data_2),
        .m_axis_data_tuser(k_2),
        .m_axis_data_tvalid(valid_fft_2),
        .m_axis_data_tready(1'b1),
        .m_axis_data_tlast(last_2),
        .event_frame_started(),
        .event_tlast_unexpected(),
        .event_tlast_missing(),
        .event_status_channel_halt(),
        .event_data_in_channel_halt(),
        .event_data_out_channel_halt()
    );
    
    xfft_0 fft_3 (
        .aclk(clk),
        .s_axis_config_tdata(16'b0),
        .s_axis_config_tvalid(1'b0),
        .s_axis_config_tready(),
        .s_axis_data_tdata(data_in_3),
        .s_axis_data_tvalid(s_valid),
        .s_axis_data_tready(ready_3),
        .s_axis_data_tlast(),
        .m_axis_data_tdata(fft_data_3),
        .m_axis_data_tuser(k_3),
        .m_axis_data_tvalid(valid_fft_3),
        .m_axis_data_tready(1'b1),
        .m_axis_data_tlast(last_3),
        .event_frame_started(),
        .event_tlast_unexpected(),
        .event_tlast_missing(),
        .event_status_channel_halt(),
        .event_data_in_channel_halt(),
        .event_data_out_channel_halt()
    );
    
    assign phase_0 = 29'b0;
    assign phase_1 = ~{4'b0, k_1, 11'b0} + 29'b1; // -  1 * pi * i * k/(N/4) 
    assign phase_2 = ~{3'b0, k_2, 12'b0} + 29'b1; // -  2 * pi * i * k/(N/4)
    assign phase_3 = ~{3'b0, k_3, 12'b0} + 29'b1 + ~{4'b0, k_3, 11'b0} + 29'b1; // -  3 * pi * i * k/(N/4)
    assign phase_3_mod = (phase_3[26] == 1'b0) ? {3'b0, phase_3[25:0]} : phase_3;  // range should be -1 to 1   

    wire k_next;

    axis_data_fifo_0 k_fifo (
      .s_axis_aresetn(resetn),
      .s_axis_aclk(clk),
      .s_axis_tvalid(valid_fft_0),
      .s_axis_tready(),
      .s_axis_tdata(k_0),
      .s_axis_tlast(last_0),
      .m_axis_tvalid(),
      .m_axis_tready(k_next),
      .m_axis_tdata(k),
      .m_axis_tlast(m_last)
    ); 

    cordic_0 cord_0 (
        .aclk(clk),
        .s_axis_phase_tvalid(valid_fft_0),
        .s_axis_phase_tdata(phase_0),
        .s_axis_cartesian_tvalid(valid_fft_0),
        .s_axis_cartesian_tdata(fft_data_0),
        .m_axis_dout_tvalid(valid_rot_0),
        .m_axis_dout_tdata(fft_rot_0)
    );

    cordic_0 cord_1 (
        .aclk(clk),
        .s_axis_phase_tvalid(valid_fft_1),
        .s_axis_phase_tdata(phase_1),
        .s_axis_cartesian_tvalid(valid_fft_1),
        .s_axis_cartesian_tdata(fft_data_1),
        .m_axis_dout_tvalid(valid_rot_1),
        .m_axis_dout_tdata(fft_rot_1)
    );
    
    cordic_0 cord_2 (
        .aclk(clk),
        .s_axis_phase_tvalid(valid_fft_2),
        .s_axis_phase_tdata(phase_2),
        .s_axis_cartesian_tvalid(valid_fft_2),
        .s_axis_cartesian_tdata(fft_data_2),
        .m_axis_dout_tvalid(valid_rot_2),
        .m_axis_dout_tdata(fft_rot_2)
    );
    
    cordic_0 cord_3 (
        .aclk(clk),
        .s_axis_phase_tvalid(valid_fft_3),
        .s_axis_phase_tdata(phase_3_mod),
        .s_axis_cartesian_tvalid(valid_fft_3),
        .s_axis_cartesian_tdata(fft_data_3),
        .m_axis_dout_tvalid(valid_rot_3),
        .m_axis_dout_tdata(fft_rot_3)
    );
    assign m_valid = k_next;
    
    //////////////////////////// Adder
    // using addsub module for better timing management
    wire [31:0] a00, a01, a10, a11, a20, a21, a30, a31;
    wire [31:0] b00, b01, b10, b11, b20, b21, b30, b31;
    
    // channel 0 
    // A + B + C + D
    c_addsub_fft_quad add_a00 (
        .A(fft_rot_0[31:0]),
        .B(fft_rot_1[31:0]),
        .CLK(clk),
        .S(a00)
    );
    
    c_addsub_fft_quad add_a01 (
        .A(fft_rot_2[31:0]),
        .B(fft_rot_3[31:0]),
        .CLK(clk),
        .S(a01)
    );
    
    c_addsub_fft_quad add_a0 (
        .A(a00),
        .B(a01),
        .CLK(clk),
        .S(data_out_0[31:0])
    );
    
    c_addsub_fft_quad add_b00 (
        .A(fft_rot_0[63:32]),
        .B(fft_rot_1[63:32]),
        .CLK(clk),
        .S(b00)
    );
    
    c_addsub_fft_quad add_b01 (
        .A(fft_rot_2[63:32]),
        .B(fft_rot_3[63:32]),
        .CLK(clk),
        .S(b01)
    );
    
    c_addsub_fft_quad add_b0 (
        .A(b00),
        .B(b01),
        .CLK(clk),
        .S(data_out_0[63:32])
    );
    
    // channel 1
    // A - iB - C + iD
    c_addsub_fft_quad add_a10 (
        .A(fft_rot_0[31:0]),
        .B(fft_rot_1[63:32]),
        .CLK(clk),
        .S(a10)
    );
    
    c_addsub_fft_quad add_a11 (
        .A(-fft_rot_2[31:0]),
        .B(-fft_rot_3[63:32]),
        .CLK(clk),
        .S(a11)
    );
    
    c_addsub_fft_quad add_a1 (
        .A(a10),
        .B(a11),
        .CLK(clk),
        .S(data_out_1[31:0])
    );
    
    c_addsub_fft_quad add_b10 (
        .A(fft_rot_0[63:32]),
        .B(-fft_rot_1[31:0]),
        .CLK(clk),
        .S(b10)
    );
    
    c_addsub_fft_quad add_b11 (
        .A(-fft_rot_2[63:32]),
        .B(fft_rot_3[31:0]),
        .CLK(clk),
        .S(b11)
    );
    
    c_addsub_fft_quad add_b1 (
        .A(b10),
        .B(b11),
        .CLK(clk),
        .S(data_out_1[63:32])
    );
 
    // A - B + C - D
    c_addsub_fft_quad add_a20 (
        .A(fft_rot_0[31:0]),
        .B(-fft_rot_1[31:0]),
        .CLK(clk),
        .S(a20)
    );
    
    c_addsub_fft_quad add_a21 (
        .A(fft_rot_2[31:0]),
        .B(-fft_rot_3[31:0]),
        .CLK(clk),
        .S(a21)
    );

    c_addsub_fft_quad add_a2 (
        .A(a20),
        .B(a21),
        .CLK(clk),
        .S(data_out_2[31:0])
    );

    c_addsub_fft_quad add_b20 (
        .A(fft_rot_0[63:32]),
        .B(-fft_rot_1[63:32]),
        .CLK(clk),
        .S(b20)
    );

    c_addsub_fft_quad add_b21 (
        .A(fft_rot_2[63:32]),
        .B(-fft_rot_3[63:32]),
        .CLK(clk),
        .S(b21)
    );

    c_addsub_fft_quad add_b2 (
        .A(b20),
        .B(b21),
        .CLK(clk),
        .S(data_out_2[63:32])
    );
    // A + iB - C - iD
    c_addsub_fft_quad add_a30 (
        .A(fft_rot_0[31:0]),
        .B(-fft_rot_1[63:32]),
        .CLK(clk),
        .S(a30)
    );
    
    c_addsub_fft_quad add_a31 (
        .A(-fft_rot_2[31:0]),
        .B(fft_rot_3[63:32]),
        .CLK(clk),
        .S(a31)
    );
    
    c_addsub_fft_quad add_a3 (
        .A(a30),
        .B(a31),
        .CLK(clk),
        .S(data_out_3[31:0])
    );

    c_addsub_fft_quad add_b30 (
        .A(fft_rot_0[63:32]),
        .B(fft_rot_1[31:0]),
        .CLK(clk),
        .S(b30)
    );

    c_addsub_fft_quad add_b31 (
        .A(-fft_rot_2[63:32]),
        .B(-fft_rot_3[31:0]),
        .CLK(clk),
        .S(b31)
    );

    c_addsub_fft_quad add_b3 (
        .A(b30),
        .B(b31),
        .CLK(clk),
        .S(data_out_3[63:32])
    );
    
    // delay 3 clk (1st adder) + 3 clk (2nd adder)
    reg [5:0] v_buf;
    always @(posedge clk) begin
        if (~resetn) begin
            v_buf <= 6'b0;
        end else begin
            v_buf[5:1] <= v_buf[4:0];
            v_buf[0] <= valid_rot_0;
        end
    end
    assign k_next = v_buf[5];

endmodule