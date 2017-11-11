module deQPSK
#(
parameter	N = 16
)
(
    clk,
	din,
	din_last,
	din_valid,
	in_ready,
	dout,
	dout_valid,
	out_ready,
	dout_last
);

input		[2*N-1:0]	   din;
input				       clk, din_valid, din_last, out_ready;
output reg			       dout_valid;
output reg			       in_ready;
output reg          	   dout_last;
output reg	[1:0]		   dout;

// Use Gray code constellation
always @(posedge clk)
begin
	if (din_valid && out_ready)
	begin
		if ({din[2*N-1],din[N-1]} == 2'b00) // 1 + j1
		begin
			dout <= 2'b10;
			dout_valid <= 1'b1;
	    end
		else if ({din[2*N-1],din[N-1]} == 2'b01) // -1 + j1
		begin
			dout <= 2'b00;
			dout_valid <= 1'b1;
	    end
		else if ({din[2*N-1],din[N-1]} == 2'b10) // 1 - j1
		begin
			dout <= 2'b11;
			dout_valid <= 1'b1;
	    end
		else                                      // -1 - j1
		begin                         
			dout <= 2'b01;
			dout_valid <= 1'b1;
	    end
	end
	else
	begin
		dout_valid <= 1'b0;
	end
	
	if (din_last)
	   dout_last <= 1'b1;
	else
	   dout_last <= 1'b0; 
	
	if (out_ready)
	   in_ready <= 1;
	else
	   in_ready <= 0;
end

endmodule