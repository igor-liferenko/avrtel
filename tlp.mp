outputtemplate:="%j.eps"; prologues:=3; fontmapline "+lhr10 <lhr10.pfb";
beginfig(0)
  u=1cm;
%  draw (-1u,0)..(10u,0);
%  draw (0,-1u)..(0,10u);

  z1=(1u,3u);
  z2=(x1+2u,y1); z2=1/2[z3,z4];
  z3=(x2,y2+.4u);
  z5=(x2+.5u,y2+.5u);
  z6=(x5,y2-.5u);
  z7=(x5,y5+1.2u);
  z8=(x5,y6-.8u);
  z9=(x8+2u,y8);
  z10=(x8,y8-.8u);
  z11=(x10,y10-.9u);
  z12=(x11,y11-.8u);
  z12=1/2[z13,z14];
  z13=(x12-.3u,y12);

  label.lft(btex old output etex, z1);
  draw z1 -- z2;
  draw z3 -- z4;
  ahlength:=.3u;
  ahangle:=45;
  drawarrow z5 -- (x2,y2+.1u);
  draw z6 -- (x2,y2-.1u);
  draw z7 -- z5;
  draw z6 -- z8;
  drawdot z8 withpen pencircle scaled 4pt;
  draw z8 -- z9;
  label.rt(btex new output etex, z9);
  draw z8 -- z10;
  draw unitsquare xscaled .3u yscaled (y10-y11) shifted (x11-.15u,y11);
  label.lft("1K", .5[z10,z11]-(.2u,0));
  draw z11 -- z12;
  draw z13 -- z14 withpen pencircle scaled 2pt;
  label.top("+12", z7);

a=1.5u; b=2.5u;
z15=(x8+a,y8+.3u);
z16=(x8,y8+b+.3u);
z17=(x8-a,y8+.3u);
z18=(x8,y8-b+.3u);
draw z15 .. z16 .. z17 .. z18 .. cycle;

endfig;

end

  ahlength:=.3cm;
  ahangle:=50;
  %pickup pencircle scaled 4pt;
  u=1cm;
  draw (0,.8cm)..(3.5cm,.8cm) withpen pencircle scaled 3 withrgbcolor (1,0,0);
  draw (3.5cm,.8cm)..(3.5cm,0) withpen pencircle scaled 3 withrgbcolor (1,0,0);
  drawarrow (.5cm,3cm)..(.5cm,1.2cm) withpen pencircle scaled 3 withrgbcolor (1,0,0);
  drawarrow (2.3cm,2.9cm)..(1.8cm,1.2cm) withpen pencircle scaled 3 withrgbcolor (1,0,0);
  drawarrow (4.3cm,2.7cm)..(3.5cm,1.2cm) withpen pencircle scaled 3 withrgbcolor (1,0,0);
  draw (8.1cm,0)..(8.1cm,.8cm) withpen pencircle scaled 3 withrgbcolor (1,0,0);
  draw (8.1cm,.8cm)..(12.4cm,.8cm) withpen pencircle scaled 3 withrgbcolor (1,0,0);
  drawarrow (6.5cm,2.5cm)..(7.9cm,1.2cm) withpen pencircle scaled 3 withrgbcolor (1,0,0);
  drawarrow (9cm,2.9cm)..(9.5cm,1.2cm) withpen pencircle scaled 3 withrgbcolor (1,0,0);
  drawarrow (11cm,3cm)..(11.2cm,1.2cm) withpen pencircle scaled 3 withrgbcolor (1,0,0);
endfig;

end
