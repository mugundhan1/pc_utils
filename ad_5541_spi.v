module ad5541_spi ( input clk,
                    input dv,
                    input [15:0] tx_data,
                    input reset,
                    output reg csn_reg,
                    output sclk,
                    output mosi,
                    output ldac
                   );

//reg loaded_data=0;
reg sclk_reg=1;
//reg csn_reg=1;
reg mosi_reg=1;
reg [15:0] tx_data_reg=0;
reg [3:0] clk_cnt=0;

// generate spi clock
always @ (posedge clk)
begin
    if (~reset)
    begin    sclk_reg<=1;
             clk_cnt<=0;
    end
    else
    begin
        clk_cnt<=clk_cnt+1;
        sclk_reg <= clk_cnt[3];
    end
end

reg tx_data_loaded=0;
reg tx_done=0;
always @ (posedge clk)
begin
    if (~reset)
    begin
        tx_data_reg<=0;
        tx_data_loaded<=0;
    end
    else
    begin
        if (dv)
        begin
            tx_data_reg<=tx_data;
            tx_data_loaded<=1;
        end
        if (tx_done)
        begin
            tx_data_loaded<=0;
        end
    end
end

reg [4:0] bit_count=0;

always @ (negedge sclk_reg)
begin
    if (~reset)
    begin
        csn_reg<=1;
        bit_count<=0;
        mosi_reg<=0;
    end
    else
    begin
        if (tx_data_loaded)
        begin
            csn_reg<=0;
            bit_count<=bit_count+1;
            mosi_reg <= tx_data_reg[15-bit_count];
        end
        if (bit_count == 16)
        begin
            csn_reg<=1;
            bit_count<=0;
            tx_done<=1;
        end
        else
            tx_done<=0;
    end    
end

assign sclk = sclk_reg & (~csn_reg);
assign mosi = mosi_reg & (~csn_reg);

wire ldac_int;

re_det re_det1(.sig(csn_reg),.clk(sclk_reg),.pulse(ldac_int));
assign ldac = ~(ldac_int);        
        
endmodule
/*
wire ld_data_done;
reg [15:0] temp_data;

fe_det fe_det1(.sig(dv),.clk(clk),.pulse(ld_data_done));

reg loaded_temp_data_reg=0;
always @ (posedge clk)
begin
    if (reset)
        begin
            temp_data<=0;
            loaded_temp_data_reg<=0;
        end
    else
    begin
        if (ld_data_done)
        begin    
            temp_data<=tx_data_reg;
            loaded_temp_data_reg<=1;
        end
    end
end

// chip select generation logic
// we need chip select to be high for 16 cycles of sclk_reg
// we need to indicate that the temp_data has been loaded into the temp_data register!
reg [31:0] cs_counter=0;

always @ (negedge sclk_reg)
begin
    if (reset)
    begin
        cs_counter<=0;
        csn_reg <=1;
        mosi_reg <=1;
    end 
    else
    begin
        if (loaded_temp_data_reg)
        begin
            cs_counter <= cs_counter+1;
            csn_reg <= 0;
        end
        if (cs_counter<16)
        begin    
              temp_data <= {temp_data[14:0],1'b0};
              mosi_reg <= temp_data[15];
         end
        if (cs_counter == 16)
        begin
                cs_counter<=0;
                csn_reg<=1;
                loaded_temp_data_reg<=0;
        end
    end 
 end     

assign sclk = sclk_reg & (~csn_reg);
assign mosi = mosi_reg & (~csn_reg);
//assign cs_n = csn_reg;

wire ldac_int;
re_det re_det1 (.sig(csn_reg),.clk(sclk_reg),.pulse(ldac_int));

assign ldac = ~ldac_int;
*/
