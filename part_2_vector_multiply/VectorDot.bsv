import Vector::*;
import BRAM::*;

// Time spent on VectorDot: 2-3

// Please annotate the bugs you find.

interface VD;
    method Action start(Bit#(8) dim_in, Bit#(2) i);
    method ActionValue#(Bit#(32)) response();
endinterface

(* synthesize *)
module mkVectorDot (VD);
    BRAM_Configure cfg1 = defaultValue;
    cfg1.memorySize = 64;
    cfg1.loadFormat = tagged Hex "v1.hex";                      // memory size should be configured we have 64 word
    BRAM1Port#(Bit#(8), Bit#(32)) a <- mkBRAM1Server(cfg1);     // now they became 32*64 bits BRAM Module same settings for cfg2
    
    BRAM_Configure cfg2 = defaultValue;
    cfg2.memorySize = 64;
    cfg2.loadFormat = tagged Hex "v2.hex";
    BRAM1Port#(Bit#(8), Bit#(32)) b <- mkBRAM1Server(cfg2);

    Reg#(Bit#(32)) output_res <- mkReg(unpack(0));

    Reg#(Bit#(8)) dim <- mkReg(0);

    Reg#(Bool) ready_start <- mkReg(False);
    Reg#(Bit#(8)) pos_a <- mkReg(unpack(0));
    Reg#(Bit#(8)) pos_b <- mkReg(unpack(0));
    Reg#(Bit#(8)) pos_out <- mkReg(unpack(0));
    Reg#(Bool) done_all <- mkReg(False);
    Reg#(Bool) done_a <- mkReg(False);
    Reg#(Bool) done_b <- mkReg(False);
    Reg#(Bool) req_a_ready <- mkReg(False);
    Reg#(Bool) req_b_ready <- mkReg(False);

    Reg#(Bit#(3)) i <- mkReg(0);					//i has to be 3 bits


    rule process_a (ready_start && !done_a && !req_a_ready&&!done_all); // guards have to be added
        a.portA.request.put(BRAMRequest{write: False, // False for read
                            responseOnWrite: False,
                            address: zeroExtend(pos_a),
                            datain: ?});

	
         	
        if (pos_a < dim*zeroExtend(i+1))                                 //"i+1" instead of "i"
            pos_a <= pos_a + 1;
        else done_a <= True;
		
        req_a_ready <= True;

    endrule

    rule process_b (ready_start && !done_b && !req_b_ready&&!done_all);
        b.portA.request.put(BRAMRequest{write: False, // False for read
                responseOnWrite: False,
                address: zeroExtend(pos_b),
                datain: ?});

        if (pos_b < dim*zeroExtend(i+1)) 
            pos_b <= pos_b + 1;
        else done_b <= True;
    
        req_b_ready <= True;
        
    endrule

    rule mult_inputs (req_a_ready && req_b_ready && !done_all);  //ready_start was added as guard
        let out_a <- a.portA.response.get();
        let out_b <- b.portA.response.get();
        
        output_res <= output_res+ out_a*out_b;     // it was not adding the result to itself every time "output_res" was being replaced.
        
        pos_out <= pos_out + 1;
        
        if (pos_out == dim-1) begin
            done_all <= True;
        end


        req_a_ready <= False;
        req_b_ready <= False;
    endrule



    method Action start(Bit#(8) dim_in, Bit#(2) i_in) if (!ready_start);
        ready_start <= True;
        dim <= dim_in;
        done_all <= False;
        pos_a <= dim_in*zeroExtend(i_in);               // for starting right the index should be "i_in" instead of "i"
        pos_b <= dim_in*zeroExtend(i_in);
        done_a <= False;
        done_b <= False;
        pos_out <= 0;
        output_res <=0;                                 // "output_res" shoule be forced to equal zero
        i <= zeroExtend(i_in);				//"i" should be 3 bits so "zeroExtended" was called		
    endmethod

    method ActionValue#(Bit#(32)) response() if (done_all);
    	ready_start <= False;                              // "ready_start" should be False for method "start" to be re-activated
        return output_res;   
    endmethod

endmodule


