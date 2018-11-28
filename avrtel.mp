%outputtemplate:="%j.eps"; prologues:=3;

verbatimtex
\font\big=cmss17
\font\tenrm=cmss10 \rm
etex

beginfig(1)
u=1cm;
r=.85u;
z0=(2.6u,9.5u);
z1=(1.3u,7.5u);
z2=(4u,7.5u);
z3=(4u,5.2u);
z4=(7.8u,5.2u);
z5=(4u,3u);
z6=(7.8u,3u);
z7=(2.4u,.9u);
z8=(5.6u,.9u);
z9=(7.8u,.9u);
label(btex \big DEVICE etex, z0);
draw unitsquare shifted (-.5,-.5) xscaled 5.1u yscaled 1.1u shifted z0;
label(btex \big ep0 etex, z1);
draw fullcircle scaled 1.7u shifted z1;
label(btex \big cfg1 etex, z2);
draw fullcircle scaled 1.7u shifted z2;
label(btex \big if1 etex, z3);
draw fullcircle scaled 1.7u shifted z3;
label(btex \big if0 etex, z4);
draw fullcircle scaled 1.7u shifted z4;
label(btex \big alt0 etex, z5);
draw fullcircle scaled 1.7u shifted z5;
label(btex \big alt0 etex, z6);
draw fullcircle scaled 1.7u shifted z6;
label(btex \big ep1 etex, z7);
draw fullcircle scaled 1.7u shifted z7;
label(btex \big ep2 etex, z8);
draw fullcircle scaled 1.7u shifted z8;
label(btex \big ep3 etex, z9);
draw fullcircle scaled 1.7u shifted z9;
draw (x1,y0-.55u) -- z1+up*r;
draw (x2,y0-.55u) -- z2+up*r;
draw z2+down*r -- z3+up*r;
draw z2+right*r rotated angle(z4-z2) -- z4+right*r rotated angle(z2-z4);
draw z3+down*r -- z5+up*r;
draw z4+down*r -- z6+up*r;
draw z5+right*r rotated angle(z7-z5) -- z7+right*r rotated angle(z5-z7);
draw z5+right*r rotated angle(z8-z5) -- z8+right*r rotated angle(z5-z8);
draw z6+down*r -- z9+up*r;
endfig;

%FIXME: why I can't specify u=1cm here?
beginfig(2)
z1=(5.5cm,1.9cm);
z2=(4cm,1.1cm);
z3=(3cm,1.1cm);
z4=(2.1cm,1.1cm);
z5=(1.3cm,1.1cm);
z6=(.4u,1.1cm);
z7=(.4u,.2);
z8=(x3,y3+.8cm);
z9=(x7-.3u,y7);
z7=1/2[z9,z10];
label.top(btex \big MCU etex, z1+up*.5cm);
label.bot(btex input pin etex, z1+left*.6cm+down*.5cm);
draw unitsquare shifted (-.5,-.5) xscaled 3cm yscaled 3.7cm shifted z1;
draw z4 -- z2;
draw z5 -- z6;
label.top(btex switch etex, z5+right*(x4-x5)/2+up*.5cm);
draw z5 -- z5+right*(x4-x5)rotated25;
draw z6 -- z7;
draw z3 -- z8;
draw z9 -- z10 withpen pencircle scaled 1.5pt;
draw unitsquare xscaled .3cm yscaled .7cm shifted (z8+left*.15cm);
z11=(x8,y8+1.5cm);
drawarrow z8+up*.7cm .. z11;
label.top(btex 5v etex, z11+up*.1cm);
endfig;
end
