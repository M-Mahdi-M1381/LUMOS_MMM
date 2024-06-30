`include "Defines.vh"

module Fixed_Point_Unit 
#(
    parameter WIDTH = 32,
    parameter FBITS = 10
)
(
    input wire clk,
    input wire reset,
    
    input wire [WIDTH - 1 : 0] operand_1,
    input wire [WIDTH - 1 : 0] operand_2,
    
    input wire [ 1 : 0] operation,

    output reg [WIDTH - 1 : 0] result,
    output reg ready
);

    always @(*)
    begin
        case (operation)
            `FPU_ADD    : begin result <= operand_1 + operand_2; ready <= 1; end
            `FPU_SUB    : begin result <= operand_1 - operand_2; ready <= 1; end
            `FPU_MUL    : begin result <= product[WIDTH + FBITS - 1 : FBITS]; ready <= product_ready; end
            `FPU_SQRT   : begin result <= root; ready <= root_ready; end
            default     : begin result <= 'bz; ready <= 0; end
        endcase
    end

    always @(posedge reset)
    begin
        if (reset)  ready = 0;
        else        ready = 'bz;
    end
    // ------------------- //
    // Square Root Circuit //
    // ------------------- //
    reg [WIDTH - 1 : 0] root;
    reg root_ready;

        /*
         *  Describe Your Square Root Calculator Circuit Here.
         */

    // ------------------ //
    // Multiplier Circuit //
    // ------------------ //   
    reg [64 - 1 : 0] product;
    reg product_ready;

    wire    [15 : 0] A1 = operand_1[15:0];
    wire    [15 : 0] A2 = operand_1[31:16];
    wire    [15 : 0] B1 = operand_2[15:0];
    wire    [15 : 0] B2 = operand_2[31:16];

    wire    [31 : 0] P1;
    wire    [31 : 0] P2;
    wire    [31 : 0] P3;
    wire    [31 : 0] P4;

    reg     [31 : 0] partialProduct1;
    reg     [31 : 0] partialProduct2;
    reg     [31 : 0] partialProduct3;
    reg     [31 : 0] partialProduct4;

    Multiplier multiplier1
    (
        .operand_1(A1),
        .operand_2(B1),
        .product(P1)
    );

    Multiplier multiplier2
    (
        .operand_1(A1),
        .operand_2(B2),
        .product(P2)
    );

    Multiplier multiplier3
    (
        .operand_1(A2),
        .operand_2(B1),
        .product(P3)
    );

    Multiplier multiplier4
    (
        .operand_1(A2),
        .operand_2(B2),
        .product(P4)
    );

    // 32-bit Multiplier Circuit
    always @(*) begin
        // Combine partial products
        partialProduct1 = P1;
        partialProduct2 = P2 << 16;
        partialProduct3 = P3 << 16;
        partialProduct4 = P4 << 32;
        
        // Sum the partial products
        product = partialProduct1 + partialProduct2 + partialProduct3 + partialProduct4;
        product_ready = 1;
    end
endmodule

module Multiplier
(
    input wire [15 : 0] operand_1,
    input wire [15 : 0] operand_2,

    output reg [31 : 0] product
);

    always @(*)
    begin
        product <= operand_1 * operand_2;
    end
endmodule