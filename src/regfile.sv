module regfile (
  input  logic         CLK_i     ,
  input  logic         RST_ni    ,
  input  logic         WRT_EN_i  ,
  input  logic [2:0]   RD_ADDR1_i,
  input  logic [2:0]   RD_ADDR2_i,
  input  logic [2:0]   WRT_DEST_i,
  input  logic [7:0]   WRT_DATA_i,
  output logic [7:0]   RD_DATA1_o,
  output logic [7:0]   RD_DATA2_o
);
  logic [7:0] Registers[7:0];
  
  always_comb begin
    RD_DATA1_o = Registers[RD_ADDR1_i];
    RD_DATA2_o = Registers[RD_ADDR2_i];
  end

  integer j;
  always_ff @(posedge CLK_i or negedge RST_ni) begin
    if (!RST_ni) begin
      for(j = 0; j < 7;j = j + 1) begin
        Registers[j] <= 32'd0;
      end
    end else if (WRT_EN_i && (|WRT_DEST_i)) begin    //i_rd_addr, avoid writing at x0
      Registers[WRT_DEST_i] <= WRT_DATA_i;
    end
  end
    
endmodule