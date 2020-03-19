`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/02 22:18:29
// Design Name: 
// Module Name: simple
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sim_quad();
    // const
    parameter DATA_MAX = 2**14;

    // output
    // dbg
//    wire [28:0] dbg_ph_0;
//    wire [28:0] dbg_ph_1;
//    wire [28:0] dbg_ph_2;
//    wire [28:0] dbg_ph_3;
    
//    wire [63:0] dbg_fft_0;
//    wire [63:0] dbg_fft_1;
//    wire [63:0] dbg_fft_2;
//    wire [63:0] dbg_fft_3;
    
//    wire [63:0] dbg_cord_0;
//    wire [63:0] dbg_cord_1;
//    wire [63:0] dbg_cord_2;
//    wire [63:0] dbg_cord_3;
        
//    wire        dbg_ready_0;
//    wire        dbg_ready_1;
//    reg         dbg_tlast;
//    reg         dbg_tready;
//    wire        dbg_valid_rot_0;
//    wire        dbg_valid_rot_1;
//    wire        dbg_valid_fft_0;
//    wire        dbg_valid_fft_1;
//    wire [13:0] dbg_k0;
//    wire [13:0] dbg_k1;
    
    
    // fft output
    wire [63:0] data_out_0;
    wire [63:0] data_out_1;
    wire [63:0] data_out_2;
    wire [63:0] data_out_3;


    reg [29:0] data_in_0;
    reg [29:0] data_in_1;
    reg [29:0] data_in_2;
    reg [29:0] data_in_3;
    
    wire [13:0] k;
//    wire dbg_k_fifo_valid;
    
    reg aclk;
    reg resetn;
    reg s_valid;
    wire m_valid;
     

    fft_quad fft_core
    (
    .data_in_0(data_in_0),
    .data_in_1(data_in_1),
    .data_in_2(data_in_2),
    .data_in_3(data_in_3),
    
    .clk(aclk),    
    .resetn(resetn),
    .s_valid(s_valid),
    
    .data_out_0(data_out_0),
    .data_out_1(data_out_1),
    .data_out_2(data_out_2),
    .data_out_3(data_out_3),
    .k(k),
    .m_valid(m_valid)
    
//    //DEBUG
//    .dbg_tlast(dbg_tlast),
//    .dbg_tready(dbg_tready),
    
//    .dbg_ph_0(dbg_ph_0),
//    .dbg_ph_1(dbg_ph_1),
//    .dbg_ph_2(dbg_ph_2),
//    .dbg_ph_3(dbg_ph_3),
    
//    .dbg_fft_0(dbg_fft_0),
//    .dbg_fft_1(dbg_fft_1),
//    .dbg_fft_2(dbg_fft_2),
//    .dbg_fft_3(dbg_fft_3),
    
//    .dbg_cord_0(dbg_cord_0),
//    .dbg_cord_1(dbg_cord_1),
//    .dbg_cord_2(dbg_cord_2),
//    .dbg_cord_3(dbg_cord_3),
    
//    .dbg_ready_0(dbg_ready_0),
//    .dbg_ready_1(dbg_ready_1),
//    .dbg_valid_rot_0(dbg_valid_rot_0),
//    .dbg_valid_rot_1(dbg_valid_rot_1),
//    .dbg_valid_fft_0(dbg_valid_fft_0),
//    .dbg_valid_fft_1(dbg_valid_fft_1),
//    .dbg_k0(dbg_k0),
//    .dbg_k1(dbg_k1),
//    .dbg_k_fifo_valid(dbg_k_fifo_valid)
    );

    // Clock generator
    parameter CLK_PERIOD = 4; // ps
    initial begin
        aclk = 1'b0;
    end

    always #(CLK_PERIOD/2) begin
        aclk  <= ~aclk;
    end

    
    // input
    integer i = 0;

    reg [29:0] wave_0[0:DATA_MAX-1];
    reg [29:0] wave_1[0:DATA_MAX-1];
    reg [29:0] wave_2[0:DATA_MAX-1];
    reg [29:0] wave_3[0:DATA_MAX-1];

    //// wave initialization
    initial begin
        $readmemb("inputdata_0.bin", wave_0);
        $readmemb("inputdata_1.bin", wave_1);
        $readmemb("inputdata_2.bin", wave_2);
        $readmemb("inputdata_3.bin", wave_3);
    end

    //// sender
    initial begin
        resetn = 1'b0;
        s_valid = 1'b0;
//        dbg_tlast = 1'b0;
//        dbg_tready = 1'b0;
        data_in_0 = 30'b0;
        data_in_1 = 30'b0;
        data_in_2 = 30'b0;
        data_in_3 = 30'b0;

        #(CLK_PERIOD*10);
        resetn = 1'b1;
    
        
        #(CLK_PERIOD*100);
        s_valid = 1'b1;
//        dbg_tready = 1'b1;
        
        while (i < DATA_MAX) begin
            data_in_0 = wave_0[i];
            data_in_1 = wave_1[i];
            data_in_2 = wave_2[i];
            data_in_3 = wave_3[i];
            i = i + 1;
//            if (i == DATA_MAX) begin
//                dbg_tlast = 1'b1;
//            end
            #CLK_PERIOD;
        end
//        dbg_tlast = 1'b0;
        s_valid = 1'b0;
    end

    ////////////////////////////////////////////////// wirter
//    reg [63:0] mem_fft_0[DATA_MAX-1:0];
//    reg [63:0] mem_fft_1[DATA_MAX-1:0];
//    reg [63:0] mem_fft_2[DATA_MAX-1:0];
//    reg [63:0] mem_fft_3[DATA_MAX-1:0];
    
//    reg [63:0] mem_rot_0[DATA_MAX-1:0];
//    reg [63:0] mem_rot_1[DATA_MAX-1:0];
//    reg [63:0] mem_rot_2[DATA_MAX-1:0];
//    reg [63:0] mem_rot_3[DATA_MAX-1:0];
    
    reg [63:0] mem_res_0[DATA_MAX-1:0];
    reg [63:0] mem_res_1[DATA_MAX-1:0];
    reg [63:0] mem_res_2[DATA_MAX-1:0];
    reg [63:0] mem_res_3[DATA_MAX-1:0];
    
//    reg [13:0] mem_k_0[DATA_MAX-1:0];
//    reg [13:0] mem_k_1[DATA_MAX-1:0];
    reg [13:0] mem_k[DATA_MAX-1:0];
    
//    reg [28:0] mem_ph_0[DATA_MAX-1:0];
//    reg [28:0] mem_ph_1[DATA_MAX-1:0];
//    reg [28:0] mem_ph_2[DATA_MAX-1:0];
//    reg [28:0] mem_ph_3[DATA_MAX-1:0];

    
    reg [14:0] counter_fft;
    reg [14:0] counter_rot;
    reg [1:0] stage;
    reg fft_fin;
    reg rot_fin;
    
    initial begin
        counter_fft = 15'b0;
        counter_rot = 15'b0;
        fft_fin = 1'b0;
        rot_fin = 1'b0;
        stage = 2'b0;
    end

    /// memory
    always @(posedge aclk) begin
//        // FFT
//        if (dbg_valid_fft_0 & ~fft_fin) begin
//            mem_k_0[counter_fft] <= dbg_k0;
//            mem_k_1[counter_fft] <= dbg_k1;
//            mem_ph_0[counter_fft] <= dbg_ph_0;
//            mem_ph_1[counter_fft] <= dbg_ph_1;
//            mem_ph_2[counter_fft] <= dbg_ph_2;
//            mem_ph_3[counter_fft] <= dbg_ph_3;
            
//            mem_fft_0[counter_fft] <= dbg_fft_0;
//            mem_fft_1[counter_fft] <= dbg_fft_1;
//            mem_fft_2[counter_fft] <= dbg_fft_2;
//            mem_fft_3[counter_fft] <= dbg_fft_3;
            
//            counter_fft <= counter_fft + 1;
//        end         
//        if (counter_fft == DATA_MAX) begin
//            fft_fin <= 1'b1;
//        end
        // ROT
        if (m_valid & ~rot_fin) begin
//            mem_rot_0[counter_rot] <= dbg_cord_0;
//            mem_rot_1[counter_rot] <= dbg_cord_1;
//            mem_rot_2[counter_rot] <= dbg_cord_2;
//            mem_rot_3[counter_rot] <= dbg_cord_3;
            
            mem_res_0[counter_rot] <= data_out_0;
            mem_res_1[counter_rot] <= data_out_1;
            mem_res_2[counter_rot] <= data_out_2;
            mem_res_3[counter_rot] <= data_out_3;
            mem_k[counter_rot] <= k;
            
            counter_rot <= counter_rot + 1;
        end
        if (counter_rot == DATA_MAX) begin
            rot_fin <= 1'b1;            
        end
        // next stage
        if (rot_fin) begin
            stage <= 2'b1;
        end
    end
    
    // file
    always @(posedge aclk) begin
        if (stage == 2'b1) begin
//            $writememb("out_fft_0.bin", mem_fft_0);
//            $writememb("out_fft_1.bin", mem_fft_1);
//            $writememb("out_fft_2.bin", mem_fft_2);
//            $writememb("out_fft_3.bin", mem_fft_3);
            
//            $writememb("out_rot_0.bin", mem_rot_0);
//            $writememb("out_rot_1.bin", mem_rot_1);
//            $writememb("out_rot_2.bin", mem_rot_2);
//            $writememb("out_rot_3.bin", mem_rot_3);
                        
            $writememb("out_res_0.bin", mem_res_0);
            $writememb("out_res_1.bin", mem_res_1);
            $writememb("out_res_2.bin", mem_res_2);
            $writememb("out_res_3.bin", mem_res_3);
            $writememb("out_k.bin", mem_k);
            
//            $writememb("out_k_0.bin", mem_k_0);
//            $writememb("out_k_1.bin", mem_k_1);

//            $writememb("out_ph_0.bin", mem_ph_0);
//            $writememb("out_ph_1.bin", mem_ph_1);
//            $writememb("out_ph_2.bin", mem_ph_2);
//            $writememb("out_ph_3.bin", mem_ph_3);
            stage <= 2'b10;
        end
        if (stage == 2'b10) begin
            $finish;
        end
    end
    

endmodule
