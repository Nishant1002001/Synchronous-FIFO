module FIFO_tb;
    reg clock;
    reg reset;
    reg w_enable;
    reg r_enable;
    reg [7:0] write_data;

    wire [7:0] read_data;
    wire full;
    wire empty;

    // Instantiate the FIFO module
    sync_FIFO uut (
        .clock(clock),
        .reset(reset),
        .w_enable(w_enable),
        .r_enable(r_enable),
        .write_data(write_data),
        .read_data(read_data),
        .full(full),
        .empty(empty)
    );

    initial begin
        clock = 0;
        forever #5 clock = ~clock; 
    end

    integer i;

    initial begin
        w_enable = 0;
        r_enable = 0;
        write_data = 0;
        reset = 1;
        i = 0;

        #20 reset = 0;
        
        // Write data 
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clock)
            if (!full) begin
                w_enable = 1;
                write_data = i + 1;
            end
           
        end
        
        // Disable write enable after writing all values
        @(posedge clock)
        w_enable = 0;
        
        // Read data
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clock)
            r_enable = 1;
        end
        
        // Disable read enable after reading all values
        @(posedge clock)
        r_enable = 0;
        #50 $stop;  
    end
endmodule
