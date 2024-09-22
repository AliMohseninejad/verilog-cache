
module Cache (
	input [5:0] address,
	input [7:0] WriteData, MemoryToCache,
	input WriteEn,
	input reset,
	input clk,
	output hit, RAMWE,
	output [7:0] ReadData, 
	output reg [7:0] CacheToMemory,
	output reg [5:0] AddressToMemory
) ;

	reg [13:0] Way1 [7:0] ;
	reg [12:0] Way0 [7:0] ;
	
	wire hit1 ;
	wire hit0 ;
	
	// hit
	assign hit1 = ( (Way1[address[2:0]][11]) && (address[5:3] == Way1[address[2:0]][10:8]) ) ;
	assign hit0 = ( (Way0[address[2:0]][11]) && (address[5:3] == Way0[address[2:0]][10:8]) ) ;
	assign hit = hit1 || hit0 ;

	// read
	assign ReadData = (hit1)? Way1[address[2:0]][7:0] : Way0[address[2:0]][7:0] ;
	
	// Write to memory enable
	assign RAMWE = (hit)? 1'b0 : ((Way1[address[2:0]][13]) && (Way1[address[2:0]][12])) 
							 || (!(Way1[address[2:0]][13]) && (Way0[address[2:0]][12])) ;

	
	integer i = 0 ;

	always @(posedge clk)
		begin
			if(reset)
				for (i = 0 ; i < 8 ; i = i + 1)
					begin
						Way1[i] <= 13'd0 ;
						Way0[i] <= 12'd0 ;	
					end
			
			else
			begin
				if(WriteEn)								// Write from Processor
				begin
					if(hit)	
					begin
						if(hit0)
							begin
								Way0[address[2:0]][12] <= 1'b1 ;
								Way0[address[2:0]][7:0] <= WriteData ;	
							end
						else
							begin
								Way1[address[2:0]][12] <= 1'b1 ;
								Way1[address[2:0]][7:0] <= WriteData ;
							end
					end
					else if(!hit)						// Writing to memory 
						if (Way1[address[2:0]][13])
							begin
								if(Way1[address[2:0]][12])
									begin
									CacheToMemory <= Way1[address[2:0]][7:0] ;
									AddressToMemory <= {Way1[address[2:0]][10:8], address[2:0]} ; 
									end
								Way1[address[2:0]][11] <= 1'b1 ;
								Way1[address[2:0]][10:8] <= address[5:3] ; 
								Way1[address[2:0]][12] <= 1'b1 ;
								Way1[address[2:0]][7:0] <= WriteData ;
							end
						else
							begin
								if(Way0[address[2:0]][12])
									begin
										CacheToMemory <= Way0[address[2:0]][7:0] ;
										AddressToMemory <= {Way0[address[2:0]][10:8], address[2:0]} ; 
									end
								Way0[address[2:0]][11] <= 1'b1 ;
								Way0[address[2:0]][10:8] <= address[5:3] ;
								Way0[address[2:0]][12] <= 1'b1 ;
								Way0[address[2:0]][7:0] <= WriteData ;
							end
				
				end
				else if(!hit)							// updating Cache while reading
					if (Way1[address[2:0]][13])
						begin
							if (Way1[address[2:0]][12])
								begin
									CacheToMemory <= Way1[address[2:0]][7:0] ;
									AddressToMemory <= {Way1[address[2:0]][10:8], address[2:0]} ;
								end
							Way1[address[2:0]][7:0] <= MemoryToCache ;
							Way1[address[2:0]][10:8] <= address[5:3] ;
							Way1[address[2:0]][11] <= 1'b1 ;	
							Way1[address[2:0]][12] <= 1'b0 ;
						end
					else
						begin
							if (Way0[address[2:0]][12])
								begin
									CacheToMemory <= Way0[address[2:0]][7:0] ;
									AddressToMemory <= {Way0[address[2:0]][10:8], address[2:0]} ;
								end
							Way0[address[2:0]][7:0] <= MemoryToCache ;
							Way0[address[2:0]][10:8] <= address[5:3] ;
							Way0[address[2:0]][11] <= 1'b1 ;	
							Way0[address[2:0]][12] <= 1'b0 ;	
						end
				if (hit)								// LRU
					Way1[address[2:0]][13] <= hit0 ;
				else
					Way1[address[2:0]][13] <= !(Way1[address[2:0]][13]) ;

			end	


		end 
	
endmodule 
