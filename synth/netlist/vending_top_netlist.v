/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : X-2025.06-SP2
// Date      : Fri Jul  3 11:25:08 2026
/////////////////////////////////////////////////////////////


module vending_top ( clk, rst, coin_in, sel_item, confirm, cancel, dispense, 
        change_out, error, display, state_out );
  input [1:0] coin_in;
  input [1:0] sel_item;
  output [7:0] change_out;
  output [7:0] display;
  output [2:0] state_out;
  input clk, rst, confirm, cancel;
  output dispense, error;
  wire   mem_write, N16, N17, N18, N19, N20, N21, N22, N23,
         \u_control_unit/N16 , \u_control_unit/N14 ,
         \u_control_unit/check_valid , \u_memory/mem[0][15] ,
         \u_memory/mem[0][14] , \u_memory/mem[0][13] , \u_memory/mem[0][10] ,
         \u_memory/mem[0][9] , \u_memory/mem[0][4] , \u_memory/mem[0][3] ,
         \u_memory/mem[0][2] , \u_memory/mem[0][1] , \u_memory/mem[0][0] ,
         \u_memory/mem[1][15] , \u_memory/mem[1][14] , \u_memory/mem[1][11] ,
         \u_memory/mem[1][10] , \u_memory/mem[1][8] , \u_memory/mem[1][4] ,
         \u_memory/mem[1][3] , \u_memory/mem[1][2] , \u_memory/mem[1][1] ,
         \u_memory/mem[1][0] , \u_memory/mem[2][15] , \u_memory/mem[2][13] ,
         \u_memory/mem[2][12] , \u_memory/mem[2][10] , \u_memory/mem[2][4] ,
         \u_memory/mem[2][3] , \u_memory/mem[2][2] , \u_memory/mem[2][1] ,
         \u_memory/mem[2][0] , \u_memory/mem[3][15] , \u_memory/mem[3][12] ,
         \u_memory/mem[3][11] , \u_memory/mem[3][9] , \u_memory/mem[3][8] ,
         \u_memory/mem[3][4] , \u_memory/mem[3][3] , \u_memory/mem[3][2] ,
         \u_memory/mem[3][1] , \u_memory/mem[3][0] , n97, n98, n99, n100, n101,
         n102, n103, n104, n105, n106, n107, n108, n109, n110, n111, n112,
         n113, n114, n115, n118, n119, n124, n125, n126, n127, n128, n129,
         n130, n133, n134, n136, n140, n141, n142, n143, n144, n145, n147,
         n148, n150, n156, n157, n158, n159, n160, n161, n164, n165, n167,
         n168, n172, n173, n174, n175, n176, n177, n178, n179, n180, n181,
         n182, n183, n184, n187, n188, n189, n190, n191, \intadd_0/CI ,
         \intadd_0/SUM[5] , \intadd_0/SUM[4] , \intadd_0/SUM[3] ,
         \intadd_0/SUM[2] , \intadd_0/SUM[1] , \intadd_0/SUM[0] ,
         \intadd_0/n6 , \intadd_0/n5 , \intadd_0/n4 , \intadd_0/n3 ,
         \intadd_0/n2 , \intadd_0/n1 , n203, n204, n205, n206, n207, n208,
         n209, n210, n211, n212, n213, n214, n215, n216, n217, n218, n219,
         n220, n221, n222, n223, n224, n225, n226, n227, n228, n229, n230,
         n231, n232, n233, n234, n235, n236, n237, n238, n239, n240, n241,
         n242, n243, n244, n245, n246, n247, n248, n249, n250, n251, n252,
         n253, n254, n255, n256, n257, n258, n259, n260, n261, n262, n263,
         n264, n265, n266, n267, n268, n269, n270, n271, n272, n273, n274,
         n275, n276, n277, n278, n279, n280, n281, n282, n283, n284, n285,
         n286, n287, n288, n289, n290, n291, n292, n293, n294, n295, n296,
         n297, n298, n299, n300, n301, n302, n303, n304, n305, n306, n307,
         n308, n309, n310, n311, n312, n313, n314, n315, n316, n317, n318,
         n319, n320, n321, n322, n323, n324, n325, n326, n329, n330, n331,
         n332, n333, n334, n335, n336, n337, n338, n339, n340, n341, n342,
         n343, n344, n345, n346, n347;
  wire   [7:0] credit;
  wire   [7:0] price;
  wire   [7:0] stock;
  assign dispense = mem_write;

  DFFX1_RVT \u_control_unit/check_valid_reg  ( .D(n207), .CLK(clk), .Q(
        \u_control_unit/check_valid ) );
  DFFX1_RVT \u_control_unit/state_reg[2]  ( .D(\u_control_unit/N16 ), .CLK(clk), .Q(state_out[2]), .QN(n329) );
  DFFX1_RVT \u_control_unit/state_reg[0]  ( .D(\u_control_unit/N14 ), .CLK(clk), .Q(state_out[0]), .QN(n339) );
  DFFX1_RVT \u_credit_reg/credit_reg[0]  ( .D(n111), .CLK(clk), .Q(credit[0]), 
        .QN(n333) );
  DFFX1_RVT \display_reg[0]  ( .D(N16), .CLK(clk), .Q(display[0]) );
  DFFX1_RVT \change_out_reg[0]  ( .D(n104), .CLK(clk), .Q(change_out[0]) );
  DFFX1_RVT \u_credit_reg/credit_reg[1]  ( .D(n112), .CLK(clk), .Q(credit[1])
         );
  DFFX1_RVT \display_reg[1]  ( .D(N17), .CLK(clk), .Q(display[1]) );
  DFFX1_RVT \change_out_reg[1]  ( .D(n103), .CLK(clk), .Q(change_out[1]) );
  DFFX1_RVT \u_credit_reg/credit_reg[2]  ( .D(n110), .CLK(clk), .Q(credit[2])
         );
  DFFX1_RVT \display_reg[2]  ( .D(N18), .CLK(clk), .Q(display[2]) );
  DFFX1_RVT \change_out_reg[2]  ( .D(n102), .CLK(clk), .Q(change_out[2]) );
  DFFX1_RVT \u_credit_reg/credit_reg[3]  ( .D(n109), .CLK(clk), .Q(credit[3])
         );
  DFFX1_RVT \display_reg[3]  ( .D(N19), .CLK(clk), .Q(display[3]) );
  DFFX1_RVT \change_out_reg[3]  ( .D(n101), .CLK(clk), .Q(change_out[3]) );
  DFFX1_RVT \u_credit_reg/credit_reg[4]  ( .D(n108), .CLK(clk), .Q(credit[4])
         );
  DFFX1_RVT \display_reg[4]  ( .D(N20), .CLK(clk), .Q(display[4]) );
  DFFX1_RVT \change_out_reg[4]  ( .D(n100), .CLK(clk), .Q(change_out[4]) );
  DFFX1_RVT \u_credit_reg/credit_reg[5]  ( .D(n107), .CLK(clk), .Q(credit[5])
         );
  DFFX1_RVT \display_reg[5]  ( .D(N21), .CLK(clk), .Q(display[5]) );
  DFFX1_RVT \change_out_reg[5]  ( .D(n99), .CLK(clk), .Q(change_out[5]) );
  DFFX1_RVT \u_credit_reg/credit_reg[6]  ( .D(n106), .CLK(clk), .Q(credit[6])
         );
  DFFX1_RVT \display_reg[6]  ( .D(N22), .CLK(clk), .Q(display[6]) );
  DFFX1_RVT \change_out_reg[6]  ( .D(n98), .CLK(clk), .Q(change_out[6]) );
  DFFX1_RVT \u_credit_reg/credit_reg[7]  ( .D(n105), .CLK(clk), .Q(credit[7])
         );
  DFFX1_RVT \display_reg[7]  ( .D(N23), .CLK(clk), .Q(display[7]) );
  DFFX1_RVT \change_out_reg[7]  ( .D(n97), .CLK(clk), .Q(change_out[7]) );
  DFFX1_RVT \u_memory/mem_reg[3][1]  ( .D(n175), .CLK(clk), .Q(
        \u_memory/mem[3][1] ) );
  DFFX1_RVT \u_memory/mem_reg[3][0]  ( .D(n176), .CLK(clk), .Q(
        \u_memory/mem[3][0] ) );
  DFFX1_RVT \u_memory/mem_reg[3][2]  ( .D(n174), .CLK(clk), .Q(
        \u_memory/mem[3][2] ) );
  DFFX1_RVT \u_memory/mem_reg[3][3]  ( .D(n173), .CLK(clk), .Q(
        \u_memory/mem[3][3] ) );
  DFFX1_RVT \u_memory/mem_reg[3][4]  ( .D(n172), .CLK(clk), .Q(
        \u_memory/mem[3][4] ) );
  DFFX1_RVT \u_memory/mem_reg[2][0]  ( .D(n160), .CLK(clk), .Q(
        \u_memory/mem[2][0] ) );
  DFFX1_RVT \u_memory/mem_reg[2][1]  ( .D(n159), .CLK(clk), .Q(
        \u_memory/mem[2][1] ) );
  DFFX1_RVT \u_memory/mem_reg[2][2]  ( .D(n158), .CLK(clk), .Q(
        \u_memory/mem[2][2] ) );
  DFFX1_RVT \u_memory/mem_reg[2][3]  ( .D(n157), .CLK(clk), .Q(
        \u_memory/mem[2][3] ) );
  DFFX1_RVT \u_memory/mem_reg[2][4]  ( .D(n156), .CLK(clk), .Q(
        \u_memory/mem[2][4] ) );
  DFFX1_RVT \u_memory/mem_reg[1][0]  ( .D(n144), .CLK(clk), .Q(
        \u_memory/mem[1][0] ) );
  DFFX1_RVT \u_memory/mem_reg[1][2]  ( .D(n142), .CLK(clk), .Q(
        \u_memory/mem[1][2] ) );
  DFFX1_RVT \u_memory/mem_reg[0][0]  ( .D(n128), .CLK(clk), .Q(
        \u_memory/mem[0][0] ) );
  DFFX1_RVT \u_memory/mem_reg[0][2]  ( .D(n126), .CLK(clk), .Q(
        \u_memory/mem[0][2] ) );
  DFFX1_RVT \u_memory/mem_reg[0][1]  ( .D(n127), .CLK(clk), .Q(
        \u_memory/mem[0][1] ) );
  DFFX1_RVT \u_memory/mem_reg[0][3]  ( .D(n125), .CLK(clk), .Q(
        \u_memory/mem[0][3] ) );
  DFFX1_RVT \u_memory/mem_reg[0][4]  ( .D(n124), .CLK(clk), .Q(
        \u_memory/mem[0][4] ) );
  DFFX1_RVT \u_memory/price_reg[0]  ( .D(n184), .CLK(clk), .Q(price[0]), .QN(
        n346) );
  DFFX1_RVT \u_memory/mem_reg[3][8]  ( .D(n168), .CLK(clk), .Q(
        \u_memory/mem[3][8] ) );
  DFFX1_RVT \u_memory/mem_reg[1][8]  ( .D(n136), .CLK(clk), .Q(
        \u_memory/mem[1][8] ) );
  DFFX1_RVT \u_memory/mem_reg[0][9]  ( .D(n119), .CLK(clk), .Q(
        \u_memory/mem[0][9] ), .QN(n345) );
  DFFX1_RVT \u_memory/price_reg[1]  ( .D(n183), .CLK(clk), .Q(price[1]), .QN(
        n334) );
  DFFX1_RVT \u_memory/mem_reg[3][9]  ( .D(n167), .CLK(clk), .Q(
        \u_memory/mem[3][9] ) );
  DFFX1_RVT \u_memory/mem_reg[0][10]  ( .D(n118), .CLK(clk), .Q(
        \u_memory/mem[0][10] ) );
  DFFX1_RVT \u_memory/price_reg[2]  ( .D(n179), .CLK(clk), .Q(price[2]), .QN(
        n335) );
  DFFX1_RVT \u_memory/mem_reg[2][10]  ( .D(n150), .CLK(clk), .Q(
        \u_memory/mem[2][10] ) );
  DFFX1_RVT \u_memory/mem_reg[1][10]  ( .D(n134), .CLK(clk), .Q(
        \u_memory/mem[1][10] ) );
  DFFX1_RVT \u_memory/price_reg[3]  ( .D(n182), .CLK(clk), .Q(price[3]), .QN(
        n336) );
  DFFX1_RVT \u_memory/mem_reg[3][11]  ( .D(n165), .CLK(clk), .Q(
        \u_memory/mem[3][11] ) );
  DFFX1_RVT \u_memory/mem_reg[1][11]  ( .D(n133), .CLK(clk), .Q(
        \u_memory/mem[1][11] ) );
  DFFX1_RVT \u_memory/price_reg[4]  ( .D(n181), .CLK(clk), .Q(price[4]), .QN(
        n337) );
  DFFX1_RVT \u_memory/mem_reg[3][12]  ( .D(n164), .CLK(clk), .Q(
        \u_memory/mem[3][12] ) );
  DFFX1_RVT \u_memory/mem_reg[2][12]  ( .D(n148), .CLK(clk), .Q(
        \u_memory/mem[2][12] ), .QN(n344) );
  DFFX1_RVT \u_memory/mem_reg[0][13]  ( .D(n115), .CLK(clk), .Q(
        \u_memory/mem[0][13] ) );
  DFFX1_RVT \u_memory/price_reg[5]  ( .D(n178), .CLK(clk), .Q(price[5]), .QN(
        n338) );
  DFFX1_RVT \u_memory/mem_reg[2][13]  ( .D(n147), .CLK(clk), .Q(
        \u_memory/mem[2][13] ) );
  DFFX1_RVT \u_memory/mem_reg[0][14]  ( .D(n114), .CLK(clk), .Q(
        \u_memory/mem[0][14] ), .QN(n343) );
  DFFX1_RVT \u_memory/mem_reg[1][14]  ( .D(n130), .CLK(clk), .Q(
        \u_memory/mem[1][14] ) );
  DFFX1_RVT \u_memory/mem_reg[0][15]  ( .D(n113), .CLK(clk), .Q(
        \u_memory/mem[0][15] ) );
  DFFX1_RVT \u_memory/price_reg[7]  ( .D(n180), .CLK(clk), .Q(price[7]), .QN(
        n341) );
  DFFX1_RVT \u_memory/mem_reg[3][15]  ( .D(n161), .CLK(clk), .Q(
        \u_memory/mem[3][15] ) );
  DFFX1_RVT \u_memory/mem_reg[2][15]  ( .D(n145), .CLK(clk), .Q(
        \u_memory/mem[2][15] ) );
  DFFX1_RVT \u_memory/mem_reg[1][15]  ( .D(n129), .CLK(clk), .Q(
        \u_memory/mem[1][15] ) );
  DFFX1_RVT \u_memory/stock_reg[0]  ( .D(n191), .CLK(clk), .Q(stock[0]), .QN(
        n332) );
  DFFX1_RVT \u_memory/stock_reg[3]  ( .D(n188), .CLK(clk), .Q(stock[3]), .QN(
        n204) );
  DFFX1_RVT \u_memory/stock_reg[4]  ( .D(n187), .CLK(clk), .Q(stock[4]), .QN(
        n203) );
  FADDX1_RVT \intadd_0/U7  ( .A(credit[2]), .B(n335), .CI(\intadd_0/CI ), .CO(
        \intadd_0/n6 ), .S(\intadd_0/SUM[0] ) );
  FADDX1_RVT \intadd_0/U6  ( .A(credit[3]), .B(n336), .CI(\intadd_0/n6 ), .CO(
        \intadd_0/n5 ), .S(\intadd_0/SUM[1] ) );
  FADDX1_RVT \intadd_0/U5  ( .A(credit[4]), .B(n337), .CI(\intadd_0/n5 ), .CO(
        \intadd_0/n4 ), .S(\intadd_0/SUM[2] ) );
  FADDX1_RVT \intadd_0/U4  ( .A(credit[5]), .B(n338), .CI(\intadd_0/n4 ), .CO(
        \intadd_0/n3 ), .S(\intadd_0/SUM[3] ) );
  FADDX1_RVT \intadd_0/U3  ( .A(credit[6]), .B(n340), .CI(\intadd_0/n3 ), .CO(
        \intadd_0/n2 ), .S(\intadd_0/SUM[4] ) );
  FADDX1_RVT \intadd_0/U2  ( .A(credit[7]), .B(n341), .CI(\intadd_0/n2 ), .CO(
        \intadd_0/n1 ), .S(\intadd_0/SUM[5] ) );
  DFFX1_RVT \u_memory/mem_reg[1][4]  ( .D(n140), .CLK(clk), .Q(
        \u_memory/mem[1][4] ) );
  DFFX1_RVT \u_memory/mem_reg[1][3]  ( .D(n141), .CLK(clk), .Q(
        \u_memory/mem[1][3] ) );
  DFFX1_RVT \u_memory/mem_reg[1][1]  ( .D(n143), .CLK(clk), .Q(
        \u_memory/mem[1][1] ) );
  DFFX1_RVT \u_memory/stock_reg[1]  ( .D(n190), .CLK(clk), .Q(stock[1]), .QN(
        n342) );
  DFFX1_RVT \u_memory/stock_reg[2]  ( .D(n189), .CLK(clk), .Q(stock[2]), .QN(
        n330) );
  DFFX1_RVT \u_memory/price_reg[6]  ( .D(n177), .CLK(clk), .Q(price[6]), .QN(
        n340) );
  DFFSSRX1_RVT \u_control_unit/state_reg[1]  ( .D(1'b0), .SETB(n207), .RSTB(
        n347), .CLK(clk), .Q(n331), .QN(state_out[1]) );
  AO21X1_RVT U222 ( .A1(n318), .A2(n269), .A3(n275), .Y(n274) );
  AO21X1_RVT U223 ( .A1(n318), .A2(n276), .A3(n275), .Y(n288) );
  AO21X1_RVT U224 ( .A1(n318), .A2(n248), .A3(n275), .Y(n261) );
  AO21X1_RVT U225 ( .A1(n318), .A2(n263), .A3(n275), .Y(n267) );
  NAND2X0_RVT U226 ( .A1(n318), .A2(n218), .Y(n243) );
  INVX2_RVT U227 ( .A(rst), .Y(n318) );
  OR2X1_RVT U228 ( .A1(n256), .A2(n253), .Y(n205) );
  NOR2X0_RVT U229 ( .A1(n259), .A2(n258), .Y(n206) );
  NOR3X0_RVT U230 ( .A1(\u_control_unit/check_valid ), .A2(n218), .A3(n214), 
        .Y(n207) );
  OR2X1_RVT U231 ( .A1(n248), .A2(\u_memory/mem[3][15] ), .Y(n234) );
  NBUFFX2_RVT U232 ( .A(sel_item[1]), .Y(n228) );
  OR2X1_RVT U233 ( .A1(n248), .A2(\u_memory/mem[3][12] ), .Y(n231) );
  OR2X1_RVT U234 ( .A1(n257), .A2(n256), .Y(n259) );
  INVX0_RVT U235 ( .A(n301), .Y(n297) );
  OA21X1_RVT U236 ( .A1(\u_memory/mem[1][15] ), .A2(n269), .A3(n236), .Y(n289)
         );
  AO21X1_RVT U237 ( .A1(n317), .A2(state_out[0]), .A3(n326), .Y(n291) );
  AND2X1_RVT U238 ( .A1(n203), .A2(n204), .Y(n211) );
  NAND3X0_RVT U240 ( .A1(state_out[1]), .A2(n329), .A3(n339), .Y(n218) );
  OR2X1_RVT U241 ( .A1(rst), .A2(cancel), .Y(n214) );
  NAND3X0_RVT U242 ( .A1(state_out[1]), .A2(state_out[0]), .A3(n329), .Y(n247)
         );
  INVX1_RVT U243 ( .A(n247), .Y(mem_write) );
  AND3X1_RVT U244 ( .A1(state_out[2]), .A2(state_out[0]), .A3(n331), .Y(error)
         );
  INVX0_RVT U245 ( .A(n214), .Y(n317) );
  OA21X1_RVT U246 ( .A1(state_out[1]), .A2(n329), .A3(n317), .Y(n326) );
  AND2X1_RVT U247 ( .A1(credit[0]), .A2(n291), .Y(N16) );
  AND2X1_RVT U248 ( .A1(credit[1]), .A2(n291), .Y(N17) );
  AND2X1_RVT U249 ( .A1(credit[2]), .A2(n291), .Y(N18) );
  AND2X1_RVT U250 ( .A1(credit[3]), .A2(n291), .Y(N19) );
  AND2X1_RVT U251 ( .A1(credit[4]), .A2(n291), .Y(N20) );
  AND2X1_RVT U252 ( .A1(credit[5]), .A2(n291), .Y(N21) );
  AND2X1_RVT U253 ( .A1(credit[6]), .A2(n291), .Y(N22) );
  AND2X1_RVT U254 ( .A1(credit[7]), .A2(n291), .Y(N23) );
  NBUFFX2_RVT U255 ( .A(coin_in[1]), .Y(n309) );
  AND3X1_RVT U256 ( .A1(n317), .A2(n329), .A3(n331), .Y(n294) );
  OA21X1_RVT U257 ( .A1(coin_in[0]), .A2(n309), .A3(n294), .Y(n314) );
  INVX0_RVT U258 ( .A(n314), .Y(n292) );
  NAND2X0_RVT U259 ( .A1(state_out[0]), .A2(n331), .Y(n209) );
  INVX0_RVT U260 ( .A(n218), .Y(n219) );
  NAND2X0_RVT U261 ( .A1(n219), .A2(\u_control_unit/check_valid ), .Y(n208) );
  OA221X1_RVT U262 ( .A1(n209), .A2(confirm), .A3(n209), .A4(n329), .A5(n208), 
        .Y(n210) );
  OAI22X1_RVT U263 ( .A1(state_out[0]), .A2(n292), .A3(n210), .A4(n214), .Y(
        \u_control_unit/N14 ) );
  NAND2X0_RVT U264 ( .A1(price[0]), .A2(n333), .Y(n319) );
  AO222X1_RVT U265 ( .A1(credit[1]), .A2(n334), .A3(credit[1]), .A4(n319), 
        .A5(n334), .A6(n319), .Y(\intadd_0/CI ) );
  NAND4X0_RVT U266 ( .A1(state_out[0]), .A2(confirm), .A3(n329), .A4(n331), 
        .Y(n215) );
  AND3X1_RVT U267 ( .A1(n342), .A2(n330), .A3(n332), .Y(n212) );
  NAND2X0_RVT U268 ( .A1(n212), .A2(n211), .Y(n213) );
  NAND2X0_RVT U269 ( .A1(\intadd_0/n1 ), .A2(n213), .Y(n216) );
  AO221X1_RVT U270 ( .A1(n215), .A2(n218), .A3(n215), .A4(n216), .A5(n214), 
        .Y(n347) );
  AND3X1_RVT U271 ( .A1(n219), .A2(\u_control_unit/check_valid ), .A3(n216), 
        .Y(n217) );
  AO222X1_RVT U272 ( .A1(n317), .A2(mem_write), .A3(n317), .A4(error), .A5(
        n317), .A6(n217), .Y(\u_control_unit/N16 ) );
  INVX0_RVT U273 ( .A(n243), .Y(n244) );
  AND2X1_RVT U274 ( .A1(n219), .A2(n318), .Y(n220) );
  INVX0_RVT U275 ( .A(sel_item[1]), .Y(n222) );
  MUX41X1_RVT U276 ( .A1(\u_memory/mem[2][0] ), .A3(\u_memory/mem[3][0] ), 
        .A2(\u_memory/mem[0][0] ), .A4(\u_memory/mem[1][0] ), .S0(sel_item[0]), 
        .S1(n222), .Y(n264) );
  AO22X1_RVT U277 ( .A1(n244), .A2(stock[0]), .A3(n220), .A4(n264), .Y(n191)
         );
  INVX0_RVT U278 ( .A(sel_item[0]), .Y(n227) );
  MUX41X1_RVT U279 ( .A1(\u_memory/mem[1][1] ), .A3(\u_memory/mem[0][1] ), 
        .A2(\u_memory/mem[3][1] ), .A4(\u_memory/mem[2][1] ), .S0(n227), .S1(
        n228), .Y(n251) );
  AO22X1_RVT U280 ( .A1(n244), .A2(stock[1]), .A3(n220), .A4(n251), .Y(n190)
         );
  MUX41X1_RVT U281 ( .A1(\u_memory/mem[1][2] ), .A3(\u_memory/mem[0][2] ), 
        .A2(\u_memory/mem[3][2] ), .A4(\u_memory/mem[2][2] ), .S0(n227), .S1(
        n228), .Y(n253) );
  AO22X1_RVT U282 ( .A1(n244), .A2(stock[2]), .A3(n220), .A4(n253), .Y(n189)
         );
  MUX41X1_RVT U283 ( .A1(\u_memory/mem[1][3] ), .A3(\u_memory/mem[0][3] ), 
        .A2(\u_memory/mem[3][3] ), .A4(\u_memory/mem[2][3] ), .S0(n227), .S1(
        n228), .Y(n256) );
  AO22X1_RVT U284 ( .A1(n244), .A2(stock[3]), .A3(n220), .A4(n256), .Y(n188)
         );
  MUX41X1_RVT U285 ( .A1(\u_memory/mem[1][4] ), .A3(\u_memory/mem[0][4] ), 
        .A2(\u_memory/mem[3][4] ), .A4(\u_memory/mem[2][4] ), .S0(n227), .S1(
        n228), .Y(n258) );
  AO22X1_RVT U286 ( .A1(n244), .A2(stock[4]), .A3(n220), .A4(n258), .Y(n187)
         );
  NAND2X0_RVT U287 ( .A1(sel_item[0]), .A2(n222), .Y(n269) );
  NAND2X0_RVT U288 ( .A1(sel_item[0]), .A2(n228), .Y(n248) );
  OA21X1_RVT U289 ( .A1(n248), .A2(\u_memory/mem[3][8] ), .A3(n318), .Y(n221)
         );
  OA21X1_RVT U290 ( .A1(\u_memory/mem[1][8] ), .A2(n269), .A3(n221), .Y(n271)
         );
  AO22X1_RVT U291 ( .A1(n244), .A2(price[0]), .A3(n243), .A4(n271), .Y(n184)
         );
  NAND2X0_RVT U292 ( .A1(n222), .A2(n227), .Y(n276) );
  INVX0_RVT U293 ( .A(n276), .Y(n240) );
  NAND2X0_RVT U294 ( .A1(n345), .A2(n240), .Y(n223) );
  AND2X1_RVT U295 ( .A1(n318), .A2(n223), .Y(n225) );
  OR2X1_RVT U296 ( .A1(n248), .A2(\u_memory/mem[3][9] ), .Y(n224) );
  AND2X1_RVT U297 ( .A1(n225), .A2(n224), .Y(n283) );
  AO22X1_RVT U298 ( .A1(n244), .A2(price[1]), .A3(n243), .A4(n283), .Y(n183)
         );
  OA21X1_RVT U299 ( .A1(n248), .A2(\u_memory/mem[3][11] ), .A3(n318), .Y(n226)
         );
  OA21X1_RVT U300 ( .A1(\u_memory/mem[1][11] ), .A2(n269), .A3(n226), .Y(n272)
         );
  AO22X1_RVT U301 ( .A1(n244), .A2(price[3]), .A3(n243), .A4(n272), .Y(n182)
         );
  NAND2X0_RVT U302 ( .A1(n228), .A2(n227), .Y(n263) );
  INVX0_RVT U303 ( .A(n263), .Y(n229) );
  NAND2X0_RVT U304 ( .A1(n344), .A2(n229), .Y(n230) );
  AND2X1_RVT U305 ( .A1(n318), .A2(n230), .Y(n232) );
  AND2X1_RVT U306 ( .A1(n232), .A2(n231), .Y(n266) );
  AO22X1_RVT U307 ( .A1(n244), .A2(price[4]), .A3(n243), .A4(n266), .Y(n181)
         );
  OA22X1_RVT U308 ( .A1(\u_memory/mem[2][15] ), .A2(n263), .A3(
        \u_memory/mem[0][15] ), .A4(n276), .Y(n233) );
  AND2X1_RVT U309 ( .A1(n318), .A2(n233), .Y(n235) );
  AND2X1_RVT U310 ( .A1(n235), .A2(n234), .Y(n236) );
  AO22X1_RVT U311 ( .A1(n244), .A2(price[7]), .A3(n243), .A4(n289), .Y(n180)
         );
  OA22X1_RVT U312 ( .A1(\u_memory/mem[2][10] ), .A2(n263), .A3(
        \u_memory/mem[0][10] ), .A4(n276), .Y(n237) );
  AND2X1_RVT U313 ( .A1(n237), .A2(n318), .Y(n238) );
  OA21X1_RVT U314 ( .A1(\u_memory/mem[1][10] ), .A2(n269), .A3(n238), .Y(n284)
         );
  AO22X1_RVT U315 ( .A1(n244), .A2(price[2]), .A3(n243), .A4(n284), .Y(n179)
         );
  OA22X1_RVT U316 ( .A1(\u_memory/mem[2][13] ), .A2(n263), .A3(
        \u_memory/mem[0][13] ), .A4(n276), .Y(n239) );
  AND2X1_RVT U317 ( .A1(n239), .A2(n318), .Y(n285) );
  AO22X1_RVT U318 ( .A1(n244), .A2(price[5]), .A3(n243), .A4(n285), .Y(n178)
         );
  NAND2X0_RVT U319 ( .A1(n343), .A2(n240), .Y(n241) );
  AND2X1_RVT U320 ( .A1(n241), .A2(n318), .Y(n242) );
  OA21X1_RVT U321 ( .A1(\u_memory/mem[1][14] ), .A2(n269), .A3(n242), .Y(n286)
         );
  AO22X1_RVT U322 ( .A1(n244), .A2(price[6]), .A3(n243), .A4(n286), .Y(n177)
         );
  OR2X1_RVT U323 ( .A1(n205), .A2(n258), .Y(n245) );
  OR2X1_RVT U324 ( .A1(n251), .A2(n264), .Y(n254) );
  NOR2X0_RVT U325 ( .A1(n245), .A2(n254), .Y(n246) );
  AO22X1_RVT U326 ( .A1(n247), .A2(n318), .A3(n246), .A4(n318), .Y(n275) );
  INVX0_RVT U327 ( .A(n264), .Y(n249) );
  AND2X1_RVT U328 ( .A1(n262), .A2(n318), .Y(n260) );
  AO22X1_RVT U329 ( .A1(\u_memory/mem[3][0] ), .A2(n261), .A3(n249), .A4(n260), 
        .Y(n176) );
  INVX0_RVT U330 ( .A(n254), .Y(n250) );
  AO21X1_RVT U331 ( .A1(n251), .A2(n264), .A3(n250), .Y(n278) );
  INVX0_RVT U332 ( .A(n261), .Y(n262) );
  AO221X1_RVT U333 ( .A1(n278), .A2(n262), .A3(n261), .A4(\u_memory/mem[3][1] ), .A5(rst), .Y(n175) );
  OR2X1_RVT U334 ( .A1(n254), .A2(n253), .Y(n257) );
  INVX0_RVT U335 ( .A(n257), .Y(n252) );
  AO21X1_RVT U336 ( .A1(n254), .A2(n253), .A3(n252), .Y(n279) );
  AO22X1_RVT U337 ( .A1(\u_memory/mem[3][2] ), .A2(n261), .A3(n260), .A4(n279), 
        .Y(n174) );
  INVX0_RVT U338 ( .A(n259), .Y(n255) );
  AO21X1_RVT U339 ( .A1(n257), .A2(n256), .A3(n255), .Y(n280) );
  AO22X1_RVT U340 ( .A1(\u_memory/mem[3][3] ), .A2(n261), .A3(n260), .A4(n280), 
        .Y(n173) );
  AO21X1_RVT U341 ( .A1(n259), .A2(n258), .A3(n206), .Y(n281) );
  AO22X1_RVT U342 ( .A1(\u_memory/mem[3][4] ), .A2(n261), .A3(n260), .A4(n281), 
        .Y(n172) );
  AO22X1_RVT U343 ( .A1(n262), .A2(n271), .A3(n261), .A4(\u_memory/mem[3][8] ), 
        .Y(n168) );
  AO22X1_RVT U344 ( .A1(n262), .A2(n283), .A3(n261), .A4(\u_memory/mem[3][9] ), 
        .Y(n167) );
  AO22X1_RVT U345 ( .A1(n262), .A2(n272), .A3(n261), .A4(\u_memory/mem[3][11] ), .Y(n165) );
  AO22X1_RVT U346 ( .A1(n262), .A2(n266), .A3(n261), .A4(\u_memory/mem[3][12] ), .Y(n164) );
  AO22X1_RVT U347 ( .A1(n262), .A2(n289), .A3(n261), .A4(\u_memory/mem[3][15] ), .Y(n161) );
  INVX0_RVT U348 ( .A(n267), .Y(n268) );
  NAND2X0_RVT U349 ( .A1(n318), .A2(n264), .Y(n277) );
  AO22X1_RVT U350 ( .A1(n268), .A2(n277), .A3(n267), .A4(\u_memory/mem[2][0] ), 
        .Y(n160) );
  AO221X1_RVT U351 ( .A1(n278), .A2(n268), .A3(n267), .A4(\u_memory/mem[2][1] ), .A5(rst), .Y(n159) );
  AND2X1_RVT U352 ( .A1(n268), .A2(n318), .Y(n265) );
  AO22X1_RVT U353 ( .A1(\u_memory/mem[2][2] ), .A2(n267), .A3(n265), .A4(n279), 
        .Y(n158) );
  AO22X1_RVT U354 ( .A1(\u_memory/mem[2][3] ), .A2(n267), .A3(n265), .A4(n280), 
        .Y(n157) );
  AO22X1_RVT U355 ( .A1(\u_memory/mem[2][4] ), .A2(n267), .A3(n265), .A4(n281), 
        .Y(n156) );
  AO22X1_RVT U356 ( .A1(n268), .A2(n284), .A3(n267), .A4(\u_memory/mem[2][10] ), .Y(n150) );
  AO22X1_RVT U357 ( .A1(n268), .A2(n266), .A3(n267), .A4(\u_memory/mem[2][12] ), .Y(n148) );
  AO22X1_RVT U358 ( .A1(n268), .A2(n285), .A3(n267), .A4(\u_memory/mem[2][13] ), .Y(n147) );
  AO22X1_RVT U359 ( .A1(n268), .A2(n289), .A3(n267), .A4(\u_memory/mem[2][15] ), .Y(n145) );
  INVX0_RVT U360 ( .A(n274), .Y(n273) );
  AO22X1_RVT U361 ( .A1(n273), .A2(n277), .A3(n274), .A4(\u_memory/mem[1][0] ), 
        .Y(n144) );
  AND2X1_RVT U362 ( .A1(n273), .A2(n318), .Y(n270) );
  AO22X1_RVT U363 ( .A1(\u_memory/mem[1][1] ), .A2(n274), .A3(n270), .A4(n278), 
        .Y(n143) );
  AO221X1_RVT U364 ( .A1(n279), .A2(n273), .A3(n274), .A4(\u_memory/mem[1][2] ), .A5(rst), .Y(n142) );
  AO22X1_RVT U365 ( .A1(\u_memory/mem[1][3] ), .A2(n274), .A3(n270), .A4(n280), 
        .Y(n141) );
  AO22X1_RVT U366 ( .A1(\u_memory/mem[1][4] ), .A2(n274), .A3(n270), .A4(n281), 
        .Y(n140) );
  AO22X1_RVT U367 ( .A1(n273), .A2(n271), .A3(n274), .A4(\u_memory/mem[1][8] ), 
        .Y(n136) );
  AO22X1_RVT U368 ( .A1(n273), .A2(n284), .A3(n274), .A4(\u_memory/mem[1][10] ), .Y(n134) );
  AO22X1_RVT U369 ( .A1(n273), .A2(n272), .A3(n274), .A4(\u_memory/mem[1][11] ), .Y(n133) );
  AO22X1_RVT U370 ( .A1(n273), .A2(n286), .A3(n274), .A4(\u_memory/mem[1][14] ), .Y(n130) );
  AO22X1_RVT U371 ( .A1(n273), .A2(n289), .A3(n274), .A4(\u_memory/mem[1][15] ), .Y(n129) );
  INVX0_RVT U372 ( .A(n288), .Y(n287) );
  AO22X1_RVT U373 ( .A1(n287), .A2(n277), .A3(n288), .A4(\u_memory/mem[0][0] ), 
        .Y(n128) );
  AND2X1_RVT U374 ( .A1(n287), .A2(n318), .Y(n282) );
  AO22X1_RVT U375 ( .A1(\u_memory/mem[0][1] ), .A2(n288), .A3(n282), .A4(n278), 
        .Y(n127) );
  AO221X1_RVT U376 ( .A1(n279), .A2(n287), .A3(n288), .A4(\u_memory/mem[0][2] ), .A5(rst), .Y(n126) );
  AO22X1_RVT U377 ( .A1(\u_memory/mem[0][3] ), .A2(n288), .A3(n282), .A4(n280), 
        .Y(n125) );
  AO22X1_RVT U378 ( .A1(\u_memory/mem[0][4] ), .A2(n288), .A3(n282), .A4(n281), 
        .Y(n124) );
  AO22X1_RVT U379 ( .A1(n287), .A2(n283), .A3(n288), .A4(\u_memory/mem[0][9] ), 
        .Y(n119) );
  AO22X1_RVT U380 ( .A1(n287), .A2(n284), .A3(n288), .A4(\u_memory/mem[0][10] ), .Y(n118) );
  AO22X1_RVT U381 ( .A1(n287), .A2(n285), .A3(n288), .A4(\u_memory/mem[0][13] ), .Y(n115) );
  AO22X1_RVT U382 ( .A1(n287), .A2(n286), .A3(n288), .A4(\u_memory/mem[0][14] ), .Y(n114) );
  AO22X1_RVT U383 ( .A1(n287), .A2(n289), .A3(n288), .A4(\u_memory/mem[0][15] ), .Y(n113) );
  OAI21X1_RVT U384 ( .A1(n333), .A2(n309), .A3(coin_in[0]), .Y(n290) );
  NAND2X0_RVT U385 ( .A1(credit[1]), .A2(n290), .Y(n296) );
  OA21X1_RVT U386 ( .A1(credit[1]), .A2(n290), .A3(n296), .Y(n293) );
  AND2X1_RVT U387 ( .A1(n292), .A2(n291), .Y(n316) );
  AO22X1_RVT U388 ( .A1(n314), .A2(n293), .A3(credit[1]), .A4(n316), .Y(n112)
         );
  INVX0_RVT U389 ( .A(n309), .Y(n302) );
  AO21X1_RVT U390 ( .A1(n294), .A2(n309), .A3(n316), .Y(n295) );
  OA222X1_RVT U391 ( .A1(credit[0]), .A2(n314), .A3(credit[0]), .A4(n302), 
        .A5(n333), .A6(n295), .Y(n111) );
  NAND2X0_RVT U392 ( .A1(coin_in[0]), .A2(n309), .Y(n305) );
  NAND2X0_RVT U393 ( .A1(n305), .A2(n296), .Y(n298) );
  AND2X1_RVT U394 ( .A1(n298), .A2(credit[2]), .Y(n301) );
  OA21X1_RVT U395 ( .A1(credit[2]), .A2(n298), .A3(n297), .Y(n299) );
  AO22X1_RVT U396 ( .A1(n314), .A2(n299), .A3(credit[2]), .A4(n316), .Y(n110)
         );
  AO22X1_RVT U397 ( .A1(n314), .A2(n300), .A3(n316), .A4(credit[3]), .Y(n109)
         );
  FADDX1_RVT U398 ( .A(credit[3]), .B(n302), .CI(n301), .CO(n306), .S(n300) );
  FADDX1_RVT U399 ( .A(credit[4]), .B(n306), .CI(n305), .S(n303) );
  AO22X1_RVT U400 ( .A1(n314), .A2(n303), .A3(n316), .A4(credit[4]), .Y(n108)
         );
  AO222X1_RVT U401 ( .A1(credit[4]), .A2(n306), .A3(credit[4]), .A4(n305), 
        .A5(n306), .A6(n305), .Y(n307) );
  FADDX1_RVT U402 ( .A(n309), .B(credit[5]), .CI(n307), .S(n304) );
  AO22X1_RVT U403 ( .A1(n314), .A2(n304), .A3(n316), .A4(credit[5]), .Y(n107)
         );
  INVX0_RVT U404 ( .A(n305), .Y(n312) );
  OR2X1_RVT U405 ( .A1(credit[4]), .A2(n306), .Y(n308) );
  AO222X1_RVT U406 ( .A1(credit[5]), .A2(n309), .A3(credit[5]), .A4(n308), 
        .A5(n309), .A6(n307), .Y(n311) );
  AO22X1_RVT U407 ( .A1(n314), .A2(n310), .A3(n316), .A4(credit[6]), .Y(n106)
         );
  FADDX1_RVT U408 ( .A(credit[6]), .B(n312), .CI(n311), .CO(n313), .S(n310) );
  HADDX1_RVT U409 ( .A0(credit[7]), .B0(n313), .SO(n315) );
  AO22X1_RVT U410 ( .A1(credit[7]), .A2(n316), .A3(n315), .A4(n314), .Y(n105)
         );
  AND4X1_RVT U411 ( .A1(state_out[2]), .A2(n317), .A3(n339), .A4(n331), .Y(
        n324) );
  OA21X1_RVT U412 ( .A1(cancel), .A2(error), .A3(n318), .Y(n325) );
  AO21X1_RVT U413 ( .A1(n324), .A2(n346), .A3(n325), .Y(n320) );
  INVX0_RVT U414 ( .A(n319), .Y(n321) );
  AO222X1_RVT U415 ( .A1(n320), .A2(credit[0]), .A3(n324), .A4(n321), .A5(n326), .A6(change_out[0]), .Y(n104) );
  FADDX1_RVT U416 ( .A(credit[1]), .B(price[1]), .CI(n321), .S(n322) );
  AO22X1_RVT U417 ( .A1(n326), .A2(change_out[1]), .A3(n324), .A4(n322), .Y(
        n323) );
  AO21X1_RVT U418 ( .A1(credit[1]), .A2(n325), .A3(n323), .Y(n103) );
  AO222X1_RVT U419 ( .A1(credit[2]), .A2(n325), .A3(n326), .A4(change_out[2]), 
        .A5(\intadd_0/SUM[0] ), .A6(n324), .Y(n102) );
  AO222X1_RVT U420 ( .A1(n326), .A2(change_out[3]), .A3(n324), .A4(
        \intadd_0/SUM[1] ), .A5(credit[3]), .A6(n325), .Y(n101) );
  AO222X1_RVT U421 ( .A1(n326), .A2(change_out[4]), .A3(n325), .A4(credit[4]), 
        .A5(\intadd_0/SUM[2] ), .A6(n324), .Y(n100) );
  AO222X1_RVT U422 ( .A1(n326), .A2(change_out[5]), .A3(n325), .A4(credit[5]), 
        .A5(\intadd_0/SUM[3] ), .A6(n324), .Y(n99) );
  AO222X1_RVT U423 ( .A1(n326), .A2(change_out[6]), .A3(n324), .A4(
        \intadd_0/SUM[4] ), .A5(credit[6]), .A6(n325), .Y(n98) );
  AO222X1_RVT U424 ( .A1(n326), .A2(change_out[7]), .A3(n325), .A4(credit[7]), 
        .A5(\intadd_0/SUM[5] ), .A6(n324), .Y(n97) );
endmodule

