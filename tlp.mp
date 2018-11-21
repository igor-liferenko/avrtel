outputtemplate:="%j.eps"; prologues:=3; fontmapline "+lhr10 <lhr10.pfb";
beginfig(0)
  u=1cm;

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

  label.lft(btex Out 1 etex, z1);
  draw z1 -- z2;
  draw z3 -- z4;
  ahlength:=.3u;
  ahangle:=45;
  drawarrow z5 -- (x2,y2+.1u);
  draw z6 -- (x2,y2-.1u);
  draw fullcircle scaled 1.2u shifted (z2+(.2u,0));
  draw z7 -- z5;
  draw z6 -- z8;
  drawdot z8 withpen pencircle scaled 4pt;
  draw z8 -- z9;
  label.rt(btex new Out 1 etex, z9);
  draw z8 -- z10;
  draw unitsquare xscaled .3u yscaled (y10-y11) shifted (x11-.15u,y11);
  label.lft("1K", .5[z10,z11]-(.2u,0));
  draw z11 -- z12;
  draw z13 -- z14 withpen pencircle scaled 2pt;
  label.top("HVCC", z7);
  label.bot("HGND", z12);

endfig;

end
