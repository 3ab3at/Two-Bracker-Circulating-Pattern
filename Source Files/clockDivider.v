module clockDivider #(parameter n = 50000000) (clk, rst, clk_out);
    input clk, rst;
    output reg clk_out;
    reg[31:0] cnt;
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            cnt <= 0;
            clk_out <= 0;
        end 
        else begin
            if (cnt == n - 1) begin
                clk_out <= ~clk_out;
                cnt <= 0;
            end
            else cnt <= cnt + 1;
        end
    end
endmodule