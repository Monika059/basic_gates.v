// adders.v
// Author: Monika
// Structural Verilog implementation of Half Adder and Full Adder
// Includes compact truth-table style testbench (no delays)

`timescale 1ns/1ps

// ---------------------------
// Half Adder
// sum = a XOR b
// carry = a AND b
// ---------------------------
module half_adder (
    input  a,
    input  b,
    output sum,
    output carry
);
    xor (sum, a, b);
    and (carry, a, b);
endmodule


// ---------------------------
// Full Adder (structural)
// Uses two Half Adders + one OR gate
// sum = a XOR b XOR cin
// carry = (a & b) | (cin & (a ^ b))
// ---------------------------
module full_adder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output carry
);
    wire s1, c1, c2;

    // First half adder
    half_adder HA1 (
        .a(a),
        .b(b),
        .sum(s1),
        .carry(c1)
    );

    // Second half adder
    half_adder HA2 (
        .a(s1),
        .b(cin),
        .sum(sum),
        .carry(c2)
    );

    // Carry-out = c1 OR c2
    or (carry, c1, c2);
endmodule


// ---------------------------
// Testbench: tb_adders
// Prints truth tables for Half Adder and Full Adder
// ---------------------------
module tb_adders;
    reg a, b, cin;
    wire sum_half, carry_half;
    wire sum_full, carry_full;

    // Instantiate Half Adder
    half_adder ha_inst (
        .a(a),
        .b(b),
        .sum(sum_half),
        .carry(carry_half)
    );

    // Instantiate Full Adder
    full_adder fa_inst (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum_full),
        .carry(carry_full)
    );

    integer i;

    initial begin
       $dumpfile("adders.vcd");
       $dumpvars(0, uut);
    end

    initial begin
        $display("=========== HALF ADDER TRUTH TABLE ===========");
        $display(" a  b | sum carry ");
        for (i = 0; i < 4; i = i + 1) begin
            a = (i >> 1) & 1;
            b = i & 1;
            #0;
            $display(" %b  %b |  %b     %b", a, b, sum_half, carry_half);
        end

        $display("\n=========== FULL ADDER TRUTH TABLE ===========");
        $display(" a  b  cin | sum carry ");
        for (i = 0; i < 8; i = i + 1) begin
            a   = (i >> 2) & 1;
            b   = (i >> 1) & 1;
            cin = i & 1;
            #0;
            $display(" %b  %b   %b  |  %b     %b", a, b, cin, sum_full, carry_full);
        end

        $display("=========== END OF TESTBENCH ===========");
        $finish;
    end
endmodule
