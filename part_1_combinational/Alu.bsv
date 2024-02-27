typedef enum {
	Add,
	ShiftL,
	And,
	Not
} InstructionType deriving (Eq,FShow, Bits);

function Bit#(32) alu (InstructionType ins, Bit#(32) v1, Bit#(32) v2);

	if (ins==Add) return v1+v2;
	else if (ins==ShiftL) return v1<<v2;
	else if (ins==And) return v1&v2;
	else  return ~v1;	

endfunction

