outputtemplate:="%j.eps"; prologues:=3;

input circuit;

verbatimtex
\font\big=cmss17
\font\tenss=cmss10 \tenss
\font\smallss=cmss8 scaled 400
\font\eightss=cmss8
etex

beginfig(1);
r=24pt;
z0=(2.6cm,9.5cm);
z1=(1.3cm,7.5cm);
z2=(4cm,7.5cm);
z3=(4cm,5.2cm);
z4=(7.8cm,5.2cm);
z5=(4cm,3cm);
z6=(7.8cm,3cm);
z7=(2.4cm,.9cm);
z8=(5.6cm,.9cm);
z9=(7.8cm,.9cm);
label(btex \big DEVICE etex, z0);
draw unitsquare shifted (-.5,-.5) xscaled 5.1cm yscaled 1.1cm shifted z0;
label(btex \big ep0 etex, z1);
draw fullcircle scaled 2r shifted z1;
label(btex \big cfg1 etex, z2);
draw fullcircle scaled 2r shifted z2;
label(btex \big if1 etex, z3);
draw fullcircle scaled 2r shifted z3;
label(btex \big if0 etex, z4);
draw fullcircle scaled 2r shifted z4;
label(btex \big alt0 etex, z5);
draw fullcircle scaled 2r shifted z5;
label(btex \big alt0 etex, z6);
draw fullcircle scaled 2r shifted z6;
label(btex \big ep1 etex, z7);
draw fullcircle scaled 2r shifted z7;
label(btex \big ep2 etex, z8);
draw fullcircle scaled 2r shifted z8;
label(btex \big ep3 etex, z9);
draw fullcircle scaled 2r shifted z9;
draw (x1,y0-.55cm) -- z1+up*r;
draw (x2,y0-.55cm) -- z2+up*r;
draw z2+down*r -- z3+up*r;
draw z2+right*r rotated angle(z4-z2) -- z4+right*r rotated angle(z2-z4);
draw z3+down*r -- z5+up*r;
draw z4+down*r -- z6+up*r;
draw z5+right*r rotated angle(z7-z5) -- z7+right*r rotated angle(z5-z7);
draw z5+right*r rotated angle(z8-z5) -- z8+right*r rotated angle(z5-z8);
draw z6+down*r -- z9+up*r;
endfig;

beginfig(2);
z1=(5.5cm,1.9cm);
z2=(4cm,1.1cm);
z3=(3cm,1.1cm);
z4=(2.1cm,1.1cm);
z5=(1.3cm,1.1cm);
z6=(.4cm,1.1cm);
z8=z3+up*23pt;
z7=(.4cm,.75pt); % height is for width of the line
z9=z7+left*9pt;
z7=1/2[z9,z10];
label.top(btex \big MCU etex, z1+up*14pt);
label.bot(btex input pin etex, z1+left*17pt+down*14pt);
draw unitsquare shifted (-.5,-.5) xscaled 3cm yscaled 3.7cm shifted z1;
draw z4 -- z2;
draw z5 -- z6;
label.top(btex switch etex, z5+right*(x4-x5)/2+up*14pt);
draw z5 -- z5+right*(x4-x5)rotated25;
draw z6 -- z7;
draw z3 -- z8;
draw z9 -- z10 withpen pencircle scaled 1.5pt;
draw unitsquare xscaled .3cm yscaled .7cm shifted (z8+left*4pt);
z11=z8+up*43pt;
drawarrow z8+up*20pt .. z11;
label.top(btex 5v etex, z11+up*3pt);
endfig;

beginfig(3);
imp:=1/2*1.5*7mm;

z0l=origin;
z0r=(2imp,0);
z1=z0l+left*2cm;
z2=z0r+right*2cm;
z4=z2+right*3mm;
x3w=4cm; x3h=2cm; z3=z4+right*1/2x3w+up*5mm;
x6s=3mm;
z6=z2+right*1/2x6s+up*1/6x6s;
z7=z2+up*2/6x6s;
z5=z3+up*1/2x3h+left*1/8x3w;
z8=z5+right*2/8x3w;

draw z1--z0l withpen line;
impedance0; label(btex ${}_?$ etex, 1/2[z0l,z0r]);
label(btex \vbox{
\hbox{In gorod power is 9V, not 12V, and ``?'' is 620R.}
\hbox{In home ``?'' is 560R.}
} etex, 1/2[z0l,z0r]+down*1cm);
draw z0r--z2 withpen line;
draw unitsquare shifted (-.5,-.5) xscaled 3mm yscaled 3mm shifted z6;
label(btex \smallss RJ11 etex, z6);
draw unitsquare shifted (-.5,-.5) xscaled x3w yscaled x3h shifted z3 withpen line;
label(btex Analog DECT phone etex, z3);
draw z7--z7+left*2mm withpen line;
label.top(btex \tt+ etex, z5); label.top(btex \tt- etex, z8);
label(btex \eightss power etex, 1/2[z5,z8]+up*1.7mm);
draw unitsquare shifted (-.5,0) xscaled (abs(z5-z8)+3mm) yscaled 4mm shifted 1/2[z5,z8];
endfig;

end
