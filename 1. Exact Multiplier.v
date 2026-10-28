module exact(a,b,y);
input [7:0] a,b;
output  [15:0]y;
wire [64:1] p;
wire [24:1] s;
wire [38:1] c;
wire [18:1] cc;  
and g1 (p[1],a[0],b[0]);
and g2 (p[2],a[1],b[0]);
and g3 (p[3],a[2],b[0]);
and g4 (p[4],a[3],b[0]);
and g5 (p[5],a[4],b[0]);
and g6 (p[6],a[5],b[0]);
and g7 (p[7],a[6],b[0]);
and g8 (p[8],a[7],b[0]);

and gg1 (p[9],a[0],b[1]);
and gg2 (p[10],a[1],b[1]);
and gg3 (p[11],a[2],b[1]);
and gg4 (p[12],a[3],b[1]);
and gg5 (p[13],a[4],b[1]);
and gg6 (p[14],a[5],b[1]);
and gg7 (p[15],a[6],b[1]);
and gg8 (p[16],a[7],b[1]);

and ge1 (p[17],a[0],b[2]);
and ge2 (p[18],a[1],b[2]);
and ge3 (p[19],a[2],b[2]);
and ge4 (p[20],a[3],b[2]);
and ge5 (p[21],a[4],b[2]);
and ge6 (p[22],a[5],b[2]);
and ge7 (p[23],a[6],b[2]);
and ge8 (p[24],a[7],b[2]);

and gf1 (p[25],a[0],b[3]);
and gf2 (p[26],a[1],b[3]);
and gf3 (p[27],a[2],b[3]);
and gf4 (p[28],a[3],b[3]);
and gf5 (p[29],a[4],b[3]);
and gf6 (p[30],a[5],b[3]);
and gf7 (p[31],a[6],b[3]);
and gf8 (p[32],a[7],b[3]);

and gh1 (p[33],a[0],b[4]);
and gh2 (p[34],a[1],b[4]);
and gh3 (p[35],a[2],b[4]);
and gh4 (p[36],a[3],b[4]);
and gh5 (p[37],a[4],b[4]);
and gh6 (p[38],a[5],b[4]);
and gh7 (p[39],a[6],b[4]);
and gh8 (p[40],a[7],b[4]);
                     
and gi1 (p[41],a[0],b[5]);
and gi2 (p[42],a[1],b[5]);
and gi3 (p[43],a[2],b[5]);
and gi4 (p[44],a[3],b[5]);
and gi5 (p[45],a[4],b[5]);
and gi6 (p[46],a[5],b[5]);
and gi7 (p[47],a[6],b[5]);
and gi8 (p[48],a[7],b[5]);  

and gj1 (p[49],a[0],b[6]);
and gj2 (p[50],a[1],b[6]);
and gj3 (p[51],a[2],b[6]);
and gj4 (p[52],a[3],b[6]);
and gj5 (p[53],a[4],b[6]);
and gj6 (p[54],a[5],b[6]);
and gj7 (p[55],a[6],b[6]);
and gj8 (p[56],a[7],b[6]);

and gk1 (p[57],a[0],b[7]);
and gk2 (p[58],a[1],b[7]);
and gk3 (p[59],a[2],b[7]);
and gk4 (p[60],a[3],b[7]);
and gk5 (p[61],a[4],b[7]);
and gk6 (p[62],a[5],b[7]);
and gk7 (p[63],a[6],b[7]);
and gk8 (p[64],a[7],b[7]);

halfadder h1(s[1],c[1],p[5],p[12]);
comp cm1(s[2],c[2],cc[1],1'b0,p[6],p[13],p[20],p[27]);
comp cm2(s[3],c[3],cc[2],cc[1],p[7],p[14],p[21],p[28]);
halfadder h2(s[4],c[4],p[35],p[42]);
comp cm3(s[5],c[5],cc[3],cc[2],p[8],p[15],p[22],p[29]);
comp cm4(s[6],c[6],cc[7],1'b0,p[36],p[43],p[50],p[57]);
comp cm5(s[7],c[7],cc[4],cc[3],p[16],p[23],p[30],p[37]);
comp cm6(s[8],c[8],cc[8],cc[7],p[44],p[51],p[58],1'b0);
comp cm7(s[9],c[9],cc[5],cc[4],p[24],p[31],p[38],p[45]);
fulladder f1(s[10],c[10],p[52],p[59],cc[8]);
comp cm8(s[11],c[11],cc[6],cc[5],p[32],p[39],p[46],p[53]);
fulladder f2(s[12],c[12],cc[6],p[40],p[47]);

//layer-2
halfadder h4(s[13],c[13],p[3],p[10]);
comp cm9(s[14],c[14],cc[9],1'b0,p[4],p[11],p[18],p[25]);
comp cm10(s[15],c[15],cc[10],cc[9],s[1],p[19],p[26],p[33]);
comp cm11(s[16],c[16],cc[11],cc[10],s[2],c[1],p[34],p[41]);
comp cm12(s[17],c[17],cc[12],cc[11],s[3],s[4],c[2],p[49]);
comp cm13(s[18],c[18],cc[13],cc[12],s[5],s[6],c[3],c[4]);
comp cm14(s[19],c[19],cc[14],cc[13],s[7],s[8],c[5],c[6]);
comp cm15(s[20],c[20],cc[15],cc[14],s[9],s[10],c[7],c[8]);
comp cm16(s[21],c[21],cc[16],cc[15],s[11],c[9],c[10],p[60]);
comp cm17(s[22],c[22],cc[17],cc[16],s[12],c[11],p[54],p[61]);
comp cm18(s[23],c[23],cc[18],cc[17],c[12],p[48],p[55],p[62]);
fulladder f3(s[24],c[24],cc[18],p[56],p[63]);
assign y[0]=p[1];
halfadder h5(y[1],c[25],p[2],p[9]);
fulladder f4(y[2],c[26],c[25],s[13],p[17]);
fulladder f5(y[3],c[27],c[26],s[14],c[13]);
fulladder f6(y[4],c[28],c[27],s[15],c[14]);
fulladder f7(y[5],c[29],c[28],s[16],c[15]);
fulladder f8(y[6],c[30],c[29],s[17],c[16]);
fulladder f9(y[7],c[31],c[30],s[18],c[17]);
fulladder f10(y[8],c[32],c[31],s[19],c[18]);
fulladder f11(y[9],c[33],c[32],s[20],c[19]);
fulladder f12(y[10],c[34],c[33],s[21],c[20]);
fulladder f13(y[11],c[35],c[34],s[22],c[21]);
fulladder f14(y[12],c[36],c[35],s[23],c[22]);
fulladder f15(y[13],c[37],c[36],s[24],c[23]);
fulladder f16(y[14],c[38],c[37],p[64],c[24]);
assign y[15] = c[38];
endmodule

module fulladder(S,Cout,i1,i2,i3);
input i1,i2,i3;
output S, Cout;  
assign S = i1^i2^i3;
assign Cout = (i1&i2)|(i2&i3)|(i1&i3);
endmodule

module halfadder(Sh,Couth,ih1,ih2);
input ih1,ih2;
output Sh,Couth;    
xor v1(Sh,ih1,ih2);
and v2(Couth,ih1,ih2);  
endmodule

module comp(compressor_sum,compressor_carryout,compressor_carry,x1,x2,x3,x4,x5);
input x1,x2,x3,x4,x5;
output compressor_sum,compressor_carryout,compressor_carry;
assign compressor_sum = x1^x2^x3^x4^x5;
assign compressor_carryout = ((x1^x2)&x3) | ((~(x1^x2))&x1);
assign compressor_carry = ((x1^x2^x3^x4)&x5) | ((~(x1^x2^x3^x4))&x4);
endmodule
