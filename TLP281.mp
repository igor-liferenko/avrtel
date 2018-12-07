outputtemplate:="%j.eps"; prologues:=3;
input makecirc; initlatex("");

beginfig(1)
  u=1cm; % TODO: re-do without "u" (use "cm" + "pt")

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

beginfig(2)
draw (-3cm,0)..(3cm,0);
draw (0,-3cm)..(0,3cm);

%inductor.a((2cm,-10mm),Up,-90,"L","xxx");
%impedance.a(origin,90,"","1K");
%transistor.a(Z.a.r+T.a.E,cpnp,0);
ground.a(origin,simple,0);
impedance1(gnd.a+up*2*imp+up*.3cm,-90,"Z1","1K");
wire(gnd.a,Z1r,nsq);
T1C=Z1l;
T1E=T1C+(0,3*bjt)rotated0;
T1B=T1C+(0,2.5*bjt)rotated(0+angle(1.5,2));
transistor1(cpnp);

wire(Z1l,T1C,nsq);

%ground.b(T.a.E,simple,180);
%centerto.A(R.a.r,R.a.l,2cm,ind);
%inductor.a(A,Up,-90,"L","");
%inductor.a(R.a.r+(2cm,0),Up,-90,"L","");
%centreof.A(R.a.r,L.a.l,cap);
%capacitor.a(c.A,normal,phi.A,"C","");

%centerto.α(pin1,pin2,dist,sym)

%resistor.a(origin,normal,90,"R","10\ohm");
%centerto.A(R.a.l,R.a.r,2cm,ind);
%inductor.a((xpart A, ypart(R.a.r-A-R.a.l)),Up,-90,"L","");
%z1=(xpart L.a.r,ypart R.a.r);
%centreof.B(R.a.r,z1,cap);
%capacitor.a(c.B,normal,phi.B,"C","");
%wire(R.a.r,C.a.l,nsq);
%wire(C.a.r,L.a.l,nsq);

%wire(L.a.l,R.a.l,udsq);
% o bien %
%wire(R.a.l,L.a.l,rlsq);

endfig;

end
