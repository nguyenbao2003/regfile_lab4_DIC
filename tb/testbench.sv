module testbench;
  logic         CLK_i     ;
  logic         RST_ni    ;
  logic         WRT_EN_i  ;
  logic [2:0]   RD_ADDR1_i;
  logic [2:0]   RD_ADDR2_i;
  logic [2:0]   WRT_DEST_i;
  logic [7:0]   WRT_DATA_i;
  logic [7:0]   RD_DATA1_o;
  logic [7:0]   RD_DATA2_o;
  
  regfile dut(
    .CLK_i (CLK_i),
	 .RST_ni (RST_ni),
	 .WRT_EN_i (WRT_EN_i),
	 .RD_ADDR1_i (RD_ADDR1_i),
	 .RD_ADDR2_i (RD_ADDR2_i),
	 .WRT_DEST_i (WRT_DEST_i),
	 .WRT_DATA_i (WRT_DATA_i),
	 .RD_DATA1_o (RD_DATA1_o),
	 .RD_DATA2_o (RD_DATA2_o)
  );
  
  initial begin
		CLK_i = 0;
		forever #15 CLK_i = ~CLK_i;  // 40 ns period
	end
	
	initial begin
	   
		// ============================= TEST 1: Reset ====================== //
		@(posedge CLK_i);
		RST_ni = 0;
		WRT_EN_i = 0;
		RD_ADDR1_i = 3'd0;
		RD_ADDR2_i = 3'd1;
		WRT_DEST_i = 3'd2;
		WRT_DATA_i = 8'd55;

		@(posedge CLK_i);
		#1;
		if (RD_DATA1_o != 8'd0) begin
		  $display ("Fail");
	   end else begin
		  $display ("Pass");
		end
		
		if (RD_DATA2_o != 8'd0) begin
		  $display ("Fail");
	   end else begin
		  $display ("Pass");
		end
		
		// ============================= TEST 2: Write to a Register ====================== //
		@(posedge CLK_i);
		RST_ni = 1;
		WRT_EN_i = 1;
		RD_ADDR1_i = 3'd0;
		RD_ADDR2_i = 3'd1;
		WRT_DEST_i = 3'd2;
		WRT_DATA_i = 8'd99;
		
		// ============================= TEST 3:  Read from Registers ====================== //
		@(posedge CLK_i);
		RST_ni = 1;
		WRT_EN_i = 0;
		RD_ADDR1_i = 3'd2;
		RD_ADDR2_i = 3'd3;
		WRT_DEST_i = 3'd0;
		WRT_DATA_i = 8'd0;
		
		#1;
		if (RD_DATA1_o != 8'd99) begin
		  $display ("Fail");
	   end else begin
		  $display ("Pass");
		end
		
		if (RD_DATA2_o != 8'd0) begin
		  $display ("Fail");
	   end else begin
		  $display ("Pass");
		end
		
		// ============================= TEST 4:  Write Disabled ====================== //
		@(posedge CLK_i);
		RST_ni = 1;
		WRT_EN_i = 0;
		RD_ADDR1_i = 3'd2;
		RD_ADDR2_i = 3'd3;
		WRT_DEST_i = 3'd3;
		WRT_DATA_i = 8'd55;
		
		#1;
		if (RD_DATA1_o != 8'd99) begin
		  $display ("Fail");
	   end else begin
		  $display ("Pass");
		end
		
		if (RD_DATA2_o != 8'd0) begin
		  $display ("Fail");
	   end else begin
		  $display ("Pass");
		end
		
		// ============================= TEST 5:  Invalid Write Address (0 Write Suppressed) ====================== //
		@(posedge CLK_i);
		RST_ni = 1;
		WRT_EN_i = 1;
		RD_ADDR1_i = 3'd0;
		RD_ADDR2_i = 3'd1;
		WRT_DEST_i = 3'd3;
		WRT_DATA_i = 8'd88;
		
		@(posedge CLK_i);
		#1;
		if (RD_DATA1_o != 8'd0) begin
		  $display ("Fail");
	   end else begin
		  $display ("Pass");
		end
		
		if (RD_DATA2_o != 8'd0) begin
		  $display ("Fail");
	   end else begin
		  $display ("Pass");
		end
		
		// ============================= TEST 6:   Write to Multiple Registers ====================== //
		@(posedge CLK_i);
		RST_ni = 1;
		WRT_EN_i = 1;
		WRT_DEST_i = 3'd4;
		WRT_DATA_i = 8'd28;
		
		@(posedge CLK_i);
	   RST_ni = 1;
		WRT_EN_i = 1;
		WRT_DEST_i = 3'd5;
		WRT_DATA_i = 8'd20;
		
		@(posedge CLK_i);
		RST_ni = 1;
		WRT_EN_i = 0;
		RD_ADDR1_i = 3'd4;
		RD_ADDR2_i = 3'd5;
		WRT_DEST_i = 3'd3;
		WRT_DATA_i = 8'd88;
		
		#1;
		if (RD_DATA1_o != 8'd28) begin
		  $display ("Fail");
	   end else begin
		  $display ("Pass");
		end
		
		if (RD_DATA2_o != 8'd20) begin
		  $display ("Fail");
	   end else begin
		  $display ("Pass");
		end
		
		// ============================= TEST 7:  Reset After Writes ====================== //
		@(posedge CLK_i);
		RST_ni = 1;
		WRT_EN_i = 1;
		WRT_DEST_i = 3'd6;
		WRT_DATA_i = 8'd42;
		
		@(posedge CLK_i);
		RST_ni = 0;
		WRT_EN_i = 1;
	   
		@(posedge CLK_i);
		RST_ni = 1;
		WRT_EN_i = 0;
		RD_ADDR1_i = 3'd1;
		RD_ADDR2_i = 3'd6;
		WRT_DEST_i = 3'd5;
		WRT_DATA_i = 8'd88;
		
		#1;
		if (RD_DATA1_o != 8'd0) begin
		  $display ("Fail");
	   end else begin
		  $display ("Pass");
		end
		
		if (RD_DATA2_o != 8'd0) begin
		  $display ("Fail");
	   end else begin
		  $display ("Pass");
		end

		#100;
		$stop;
	end
endmodule