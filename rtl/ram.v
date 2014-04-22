module ram (clk, addr, data_in, write_en, data_out, rom_addr, rom_out);
    parameter ADDR_SIZE = 12;
    parameter WORD_SIZE = 16;
    parameter ROM_SIZE = 256;  
    
    input wire clk, write_en;
    input wire [ADDR_SIZE-1:0] addr;
    input wire [ADDR_SIZE-1:0] rom_addr;
    input wire [WORD_SIZE-1:0] data_in;
    output reg [WORD_SIZE-1:0] data_out;
    output reg [WORD_SIZE-1:0] rom_out;
    
    
    reg [WORD_SIZE-1:0] rom [ROM_SIZE-1:0];
    
    always @(negedge clk) begin
        if(write_en)
            rom[addr] <= data_in;
        data_out <= rom[addr];
        rom_out <= rom[rom_addr];
    end
        
    initial
        $readmemh("data/ram.txt",rom);
        
endmodule
    