
module Top (
	input Clk,
	input Reset,
	output Hit,
	output [7:0] MemSysOut
) ;
	wire RWB ;
	reg start;
	wire [5:0] address ;
	wire [7:0] data ;
	
	MemorySystem memsys1 (Clk,Reset,RWB,address,data,Hit,MemSysOut) ;
	
	Processor processor1 (Clk,start,RWB,address,data) ;

	integer k = 0 ;
	always @(posedge Clk)
		begin
			if (k < 3)
				k = k + 1 ;
			if (Reset)
				begin
					k = 0 ;
					start = 0 ;
				end
			if (k == 0)
				start = 1 ;
			if (k == 1)
				start = 0 ;	
		end	
endmodule 

