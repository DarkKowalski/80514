module alu(
    // verilator lint_off UNUSED
    input clk,
    input rst_n,
    // verilator lint_on UNUSED

    input [7:0] a,
    input [7:0] b,
    output [7:0] o,
    output [7:0] shift_o,

    // Carry bit
    input cy_i,
    output cy_o,

    // ALU operation
    // add 3'h00
    // sub 3'h01
    // and 3'h02
    // or  3'h03
    // not 3'h04
    // xor 3'h05
    input [2:0] method,

    // logical right shift     3'h00
    // right rotate            3'h01
    // arithmetic right shift 3'h02
    // left shit               3'h03
    // left rotate             3'h04
    input [2:0] shift_method
);

reg [8:0] result; // extra 1 bit for the carry bit

always @(*) begin
    case (method)
        0: result = a + b + { 8'b0, cy_i };
        1: result = a - b - { 8'b0, cy_i };
        2: result = { 1'b0, a } & { 1'b0, b };
        3: result = { 1'b0, a } | { 1'b0, b };
        4: result = { 1'b0, ~a };
        5: result = { 1'b0, a ^ b };
        default: result = 9'bx;
    endcase
end

assign cy_o = result[8];
assign o = result[7:0];

reg [7:0] shift_result;
always @(*) begin
    case (shift_method)
        0: shift_result = { 1'b0, a[7:1] };
        1: shift_result = { a[0], a[7:1] };
        2: shift_result = { a[7], a[7:1] };
        3: shift_result = { a[6:0], 1'b0 };
        4: shift_result = { a[6:0], a[7] };
        default: shift_result = 8'bx;
    endcase
end

assign shift_o = shift_result;

endmodule
