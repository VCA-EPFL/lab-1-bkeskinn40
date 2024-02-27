import Vector::*;

typedef Bit#(16) Word;

function Vector#(16, Word) naiveShfl(Vector#(16, Word) in, Bit#(4) shftAmnt);
    Vector#(16, Word) resultVector = in; 
    for (Integer i = 0; i < 16; i = i + 1) begin
        Bit#(4) idx = fromInteger(i);
        resultVector[i] = in[shftAmnt+idx];
    end
    return resultVector;
endfunction


function Vector#(16, Word) barrelLeft(Vector#(16, Word) in, Bit#(4) shftAmnt);
	
	Vector#(16, Word) resultVector2 = replicate(0);
	Vector#(16, Word) resultVector3 = replicate(0);
	Vector#(16, Word) resultVector4 = replicate(0);
	Vector#(16, Word) resultVector5 = replicate(0);		
	if(shftAmnt[0]==1) 
		for (Integer i = 0; i < 16; i = i + 1) begin
        		Bit#(4) idx = fromInteger(i);
        		resultVector2[i] = in[1+idx];
    		end
	else	resultVector2=in;
	if(shftAmnt[1]==1)	
		for (Integer i = 0; i < 16; i = i + 1) begin
        		Bit#(4) idx = fromInteger(i);
        		resultVector3[i] = resultVector2[2+idx];
    		end
	else	resultVector3=resultVector2;
	if(shftAmnt[2]==1)	
		for (Integer i = 0; i < 16; i = i + 1) begin
        		Bit#(4) idx = fromInteger(i);
        		resultVector4[i] = resultVector3[4+idx];
    		end
	else	resultVector4=resultVector3;	
	if(shftAmnt[3]==1)	
		for (Integer i = 0; i < 16; i = i + 1) begin
        		Bit#(4) idx = fromInteger(i);
        		resultVector5[i] = resultVector4[8+idx];
    		end
	else	resultVector5=resultVector4;	
	
	
	
    return resultVector5;
    // Implementation of a left barrel shifter, presented in recitation
endfunction
