import Vector::*;

typedef struct {
 Bool valid;
 Bit#(31) data;
 Bit#(4) index;
} ResultArbiter deriving (Eq, FShow);

function ResultArbiter arbitrate(Vector#(16, Bit#(1)) ready, Vector#(16, Bit#(31)) data);
	
	ResultArbiter a;
	a.valid=False;
	a.data=0;
	a.index=0;
	for(Integer i=0;i<16;i=i+1)begin
		if(ready[i]==1)begin
		a.valid=True;
		a.index=fromInteger(i);
		a.data=data[i];
		end
	end
	return  a;
	// TODO
endfunction

