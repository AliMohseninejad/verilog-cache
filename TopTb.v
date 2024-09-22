
`timescale 1 ns/ 1 ps
module TopTb();

integer i,HitNum = 0;

/*-----------------------------------------------------------------------------------------------
    				  Wires and registers
-------------------------------------------------------------------------------------------------*/
reg  clock, reset;								// clock , reset register
wire Hit;
wire [7:0]MemSysOut;
/*-----------------------------------------------------------------------------------------------
    				  Generating Reset and Clock
-------------------------------------------------------------------------------------------------*/
initial  				// meghdar dahi avalie reset va clock 
     begin
	clock = 1'b0 ;
     end

always 					// sakhtan clock be dore 20ns 
     begin
	#5 clock = 1 ;
	#5 clock = 0 ;
     end

	 


initial                                                
begin                                                  
    reset=1;
	@(posedge clock);
	reset=0;
	for(i=0;i<100;i=i+1)begin
		@(posedge clock);
		#1;
		HitNum=HitNum+Hit;
		$display("Memory Out: %d\n", MemSysOut);
	end
	$display("The Number of Hits is: %d", HitNum);
	$stop;
	
end    
                                          
wire start, RWB ;
wire [5:0] address ;
wire [7:0] data ;
wire [13:0] way1 [7:0] ;
wire [12:0] way0 [7:0] ;

assign start = T1.start ;
assign RWB = T1.RWB ;
assign address = T1.address ;
assign data = T1.data ;
assign way1[7] = T1.memsys1.cache1.Way1[7] ;
assign way0[7] = T1.memsys1.cache1.Way0[7] ;

assign way1[6] = T1.memsys1.cache1.Way1[6] ;
assign way0[6] = T1.memsys1.cache1.Way0[6] ;

assign way1[5] = T1.memsys1.cache1.Way1[5] ;
assign way0[5] = T1.memsys1.cache1.Way0[5] ;

assign way1[4] = T1.memsys1.cache1.Way1[4] ;
assign way0[4] = T1.memsys1.cache1.Way0[4] ;

assign way1[3] = T1.memsys1.cache1.Way1[3] ;
assign way0[3] = T1.memsys1.cache1.Way0[3] ;

assign way1[2] = T1.memsys1.cache1.Way1[2] ;
assign way0[2] = T1.memsys1.cache1.Way0[2] ;

assign way1[1] = T1.memsys1.cache1.Way1[1] ;
assign way0[1] = T1.memsys1.cache1.Way0[1] ;

assign way1[0] = T1.memsys1.cache1.Way1[0] ;
assign way0[0] = T1.memsys1.cache1.Way0[0] ;


Top T1(.Clk(clock),.Reset(reset),.Hit(Hit),.MemSysOut(MemSysOut));

                                                
endmodule

