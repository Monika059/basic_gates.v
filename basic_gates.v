// basic_gates.v
// Author: Monika
// Minimal structural Verilog implementations of basic gates,
// plus NAND-only and NOR-only universal demonstrations and a compact testbench.

`timescale 1ns/1ps

// 2-input AND gate (structural)
module and_gate (
    input  a,
    input  b,
    output y
);
    and u_and (y, a, b);
endmodule

// 2-input OR gate (structural)
module or_gate (
    input  a,
    input  b,
    output y
);
    or u_or (y, a, b);
endmodule

// NOT gate (structural)
module not_gate (
    input  a,
    output y
);
    not u_not (y, a);
endmodule

// 2-input NAND gate (structural)
module nand_gate (
    input  a,
    input  b,
    output y
);
    nand u_nand (y, a, b);
endmodule

// 2-input NOR gate (structural)
module nor_gate (
    input  a,
    input  b,
    output y
);
    nor u_nor (y, a, b);
endmodule

// 2-input XOR gate (structural)
module xor_gate (
    input  a,
    input  b,
    output y
);
    xor u_xor (y, a, b);
endmodule

// 2-input XNOR gate (structural)
module xnor_gate (
    input  a,
    input  b,
    output y
);
    xnor u_xnor (y, a, b);
endmodule


// ---------------------------
// Universal NAND-only demo
// Build NOT, AND, OR, XOR using only NAND primitives.
// ---------------------------
module universal_nand_demo (
    input  a,
    input  b,
    output not_a,
    output and_ab,
    output or_ab,
    output xor_ab
);
    // NOT a  = NAND(a,a)
    wire nand_a_a;
    nand u1 (nand_a_a, a, a);
    assign not_a = nand_a_a;

    // AND(a,b) = NOT(NAND(a,b)) = NAND( NAND(a,b), NAND(a,b) )
    wire nand_ab;
    nand u2 (nand_ab, a, b);
    nand u3 (and_ab, nand_ab, nand_ab);

    // OR(a,b) = NAND( NOT a, NOT b ) ; where NOT a = NAND(a,a)
    wire nand_a_a2, nand_b_b;
    nand u4 (nand_a_a2, a, a); // NOT a
    nand u5 (nand_b_b, b, b); // NOT b
    nand u6 (or_ab, nand_a_a2, nand_b_b);

    // XOR using NANDs:
    // XOR = (a & ~b) | (~a & b)
    // Using NAND implementation:
    wire na, nb;
    wire t1, t2, t3;
    nand u7 (na, a, a);     // na = ~a
    nand u8 (nb, b, b);     // nb = ~b

    nand u9  (t1, a, nb);   // t1 = ~(a & ~b)
    nand u10 (t2, na, b);   // t2 = ~(~a & b)
    nand u11 (t3, t1, t2);  // xor = ~( ~(a&~b) & ~(~a&b) ) -> equals (a&~b)|(~a&b)
    assign xor_ab = t3;
endmodule


// ---------------------------
// Universal NOR-only demo
// Build NOT, AND, OR, XOR using only NOR primitives.
// ---------------------------
module universal_nor_demo (
    input  a,
    input  b,
    output not_a,
    output and_ab,
    output or_ab,
    output xor_ab
);
    // NOT a = NOR(a, a)
    nor n1 (not_a, a, a);

    // OR(a,b) = NOT( NOR(a,b) ) = NOR( NOR(a,b), NOR(a,b) )
    wire nor_ab;
    nor n2 (nor_ab, a, b);
    nor n3 (or_ab, nor_ab, nor_ab);

    // AND(a,b) = NOR( NOT a, NOT b ) where NOT a = NOR(a,a)
    wire na, nb;
    nor n4 (na, a, a); // ~a
    nor n5 (nb, b, b); // ~b
    nor n6 (and_ab, na, nb);

    // XOR using NORs:
    // XOR = (a & ~b) | (~a & b)
    // Implement using NOR network:
    wire t1, t2, t3, t4, t5;
    nor n7 (t1, a, a);      // t1 = ~a
    nor n8 (t2, b, b);      // t2 = ~b
    nor n9 (t3, a, t2);     // t3 = ~(a | ~b) => ~(a | ~b)
    nor n10 (t4, t1, b);    // t4 = ~(~a | b)
    nor n11 (t5, t3, t4);   // t5 = ~( t3 | t4 ) -> yields (a&~b)|( ~a&b )
    assign xor_ab = t5;
endmodule


// ---------------------------
// Compact testbench: tb_basic_gates
// Single initial block prints truth-tables for all gates.
// No timing delays, succinct truth-table style output.
// ---------------------------
module tb_basic_gates;
    reg a;
    reg b;

    // outputs for primitive modules
    wire y_and, y_or, y_not_a, y_nand, y_nor, y_xor, y_xnor;

    // outputs for universal demos
    wire un_not_a, un_and_ab, un_or_ab, un_xor_ab;
    wire nor_not_a, nor_and_ab, nor_or_ab, nor_xor_ab;

    // instantiate primitive gates
    and_gate  u_and  (.a(a), .b(b), .y(y_and));
    or_gate   u_or   (.a(a), .b(b), .y(y_or));
    not_gate  u_not  (.a(a),         .y(y_not_a));
    nand_gate u_nand (.a(a), .b(b),  .y(y_nand));
    nor_gate  u_nor  (.a(a), .b(b),  .y(y_nor));
    xor_gate  u_xor  (.a(a), .b(b),  .y(y_xor));
    xnor_gate u_xnor (.a(a), .b(b),  .y(y_xnor));

    // instantiate universal demos
    universal_nand_demo u_nand_demo (.a(a), .b(b),
                                     .not_a(un_not_a),
                                     .and_ab(un_and_ab),
                                     .or_ab(un_or_ab),
                                     .xor_ab(un_xor_ab));

    universal_nor_demo  u_nor_demo  (.a(a), .b(b),
                                     .not_a(nor_not_a),
                                     .and_ab(nor_and_ab),
                                     .or_ab(nor_or_ab),
                                     .xor_ab(nor_xor_ab));

    integer i;

    // waveform generation
  initial begin
    $dumpfile("basic_gates.vcd");
    $dumpvars(0, uut);
  end

    initial begin
        $display("===== BASIC GATES TRUTH TABLES =====");
        $display("Format: a b | AND OR NAND NOR XOR XNOR | NOT(a) | NAND-demo(and/or/xor) | NOR-demo(and/or/xor)");
        for (i = 0; i < 4; i = i + 1) begin
            a = (i >> 1) & 1;
            b = i & 1;
            #0; // no timing delays, but allow net updates
            $display("%b %b |  %b   %b   %b    %b    %b    %b  |   %b    |   %b/%b/%b          |   %b/%b/%b",
                     a, b,
                     y_and, y_or, y_nand, y_nor, y_xor, y_xnor,
                     y_not_a,
                     un_and_ab, un_or_ab, un_xor_ab,
                     nor_and_ab, nor_or_ab, nor_xor_ab
            );
        end

        // NOT-only table for completeness (a = 0/1)
        $display("\nNOT gate truth table (a | not(a) native | not(a) nand-demo | not(a) nor-demo)");
        a = 0; #0;
        $display("%b |      %b            |        %b          |       %b", a, y_not_a, un_not_a, nor_not_a);
        a = 1; #0;
        $display("%b |      %b            |        %b          |       %b", a, y_not_a, un_not_a, nor_not_a);

        $display("===== END OF TESTBENCH =====");
        $finish;
    end
endmodule
