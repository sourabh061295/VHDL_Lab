/* Generated by Yosys 0.9+2406 (git sha1 be6638e5, gcc 9.3.0-10ubuntu2 -fPIC -Os) */

module add(a, b, ci, s, co);
  wire [31:0] _0_;
  wire [30:0] _1_;
  (* unused_bits = "5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31" *)
  wire [31:0] _2_;
  input [3:0] a;
  input [3:0] b;
  input ci;
  output co;
  output [3:0] s;
  assign _0_ = { 28'h0000000, a } + { 28'h0000000, b };
  assign _1_ = ci ? 31'h00000001 : 31'h00000000;
  assign { _2_[31:5], co, s } = _0_ + { 1'h0, _1_ };
  assign _2_[4:0] = { co, s };
endmodule
