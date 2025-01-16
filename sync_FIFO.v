module sync_FIFO(
    input wire clock,
    input wire reset,
    input wire w_enable,
    input wire r_enable,
    input wire [7:0] write_data,      
    output reg [7:0] read_data, 
    output wire full,
    output wire empty
);

    reg [7:0] memory [15:0];  //16X8
    reg [4:0] FIFO_counter = 0;
    reg [3:0] wrpt = 0;
    reg [3:0] rpt = 0;

    // Empty and Full 
    assign empty = (FIFO_counter == 0);
    assign full = (FIFO_counter == 16);

    // Write 
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            wrpt <= 0;
            FIFO_counter <= 0;
        end else if (w_enable && !full) begin
            memory[wrpt] <= write_data;
            if (wrpt == 15)
                wrpt <= 0;  
            else
                wrpt <= wrpt + 1;  
            FIFO_counter <= FIFO_counter + 1;
        end
    end

    // Read 
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            rpt <= 0;
            read_data <= 0;
        end else if (r_enable && !empty) begin
            read_data <= memory[rpt];
            if (rpt == 15)
                rpt <= 0;  
            else
                rpt <= rpt + 1;  
            FIFO_counter <= FIFO_counter - 1;
        end
    end
    
endmodule
