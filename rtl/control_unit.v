`timescale 1ns / 1ps

module control_unit();
    parameter ADDR_SIZE = 12;
    parameter WORD_SIZE = 16;

    reg sysclk;
    initial begin //clock
        sysclk <= 1'b1;
        forever #1 sysclk = ~sysclk;
    end
    
    initial begin
        $dumpfile("control_unit.vcd");
        $dumpvars;
    end

    /* 
    * Instructions:
    * 0: ACC := [S]
    * 1: [S] := ACC
    * 2: ACC:= ACC + [S]
    * 3: ACC := ACC - [S]
    * 4: PC := S
    * 5: PC := S if ACC >=0
    * 6: PC :=S if ACC != 0
    * 7: HALT
    * /

    /* 
    * Specifications:
    * posedge: exec
    * negedge: fetch
    */

    //Registers
    reg [WORD_SIZE-1:0] acc;
    reg [ADDR_SIZE-1:0] ip;
    reg [WORD_SIZE-1:0] ir;

    //Memory
    reg [ADDR_SIZE-1:0] mem_addr;
    reg [WORD_SIZE-1:0] mem_in;
    wire [WORD_SIZE-1:0] mem_out;
    wire [WORD_SIZE-1:0] rom_out;
    reg mem_write;

    ram ram_blk(
        .clk(sysclk),
        .addr(mem_addr),
        .data_in(mem_in),
        .write_en(mem_write),
        .data_out(mem_out),
        .rom_addr(ip),
        .rom_out(rom_out)
    );
    
    initial begin //default register values
        ir <= 16'h4000;
        ip <= 0;
        mem_addr <= 0;
        mem_in <= 0;
        mem_write <= 0;
        acc <= 0;
    end
    
    //0/1 -> Fetch/Exec
    reg state = 1;
    
    always @(posedge sysclk) begin
        
        state <= ~state; //Alternate state
        
        if (state) begin //Exec
            case (ir[WORD_SIZE-1:WORD_SIZE-4])
                4'h0: begin//ACC := [S]
                        acc <= mem_out;
                    end
                4'h1: begin //[S] := ACC
                        mem_in <= acc;
                        mem_addr <= ir[WORD_SIZE-5:0];
                        mem_write <= 1;
                    end
                4'h2: begin//ACC:= ACC + [S]
                        acc <= acc + mem_out;
                    end
                4'h3: begin//ACC := ACC - [S]
                        acc <= acc - mem_out;
                    end
                4'h4: begin// PC := S
                        ip <= ir[WORD_SIZE-5:0];
                    end
                4'h5: begin //PC := S if ACC >=0
                        if (acc[WORD_SIZE-1] == 1'b0)
                            ip <= ir[WORD_SIZE-5:0];
                    end
                4'h6: begin //PC :=S if ACC != 0
                        if (acc != 8'd0)
                            ip <= ir[WORD_SIZE-5:0];
                    end
                default: $finish;
            endcase
        end
        else begin //Fetch
            ir <= rom_out;
            ip <= ip + 1; 
            mem_write <= 0;
            mem_addr <= rom_out[WORD_SIZE-5:0]; //read address
        end
    end
endmodule