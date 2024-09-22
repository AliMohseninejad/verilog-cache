
module MemorySystem	(
	input clk,
	input reset,
	input RWB,
	input [5:0] address,
	input [7:0] data,
	output hit,
	output [7:0] MemSysOut 
);
	wire [7:0] MemoryToCache, ReadDataCache, CacheToMemory ;
	wire [5:0] AddressToMemory ;
	wire RAMWE ;
	
	Cache cache1 (address,data,MemoryToCache,RWB,reset,clk,hit,RAMWE,ReadDataCache,CacheToMemory,AddressToMemory) ;

	RAM ram1 (MemoryToCache,CacheToMemory,reset,address,AddressToMemory,clk,RAMWE,(!hit)) ;

	assign MemSysOut = (RWB) ? 8'd0 : ((hit) ? ReadDataCache : MemoryToCache) ;

endmodule 