outputtemplate:="%j.eps"; prologues:=3;

input circuit;

verbatimtex
\font\big=cmss17
\font\tenss=cmss10 \tenss
\font\smallss=cmss8 scaled 400
\font\eightss=cmss8
\font\twlbs=cmssbx10 scaled 1200
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

z0l=(0,-10mm);
z0r=z0l+right*2imp;
z1=z0l+left*2cm;
z2=z0r+right*2cm+up*2mm;
z19=z2+left*2mm;
z4=z19+right*3mm;
x6s=3mm;
z6=z2+right*1/2x6s+up*1/6x6s;
z7=z2+up*2/6x6s;
x3w=4cm; x3h=2cm; z3=z2+right*x6s+right*1/2x3w+up*5mm;
z5=z3+up*1/2x3h+right*(18/40x3w-3mm);
z8=z5+right*2/40x3w;
z9=z3+up*1/2x3h+left*(18/40x3w-3mm);
z10=z9+right*3mm;
x11=x19; y11=y7;
z12=z11+up*2mm;
z13=z12+left*2cm;
z14=z11+left*5mm+up*3cm;
z15=z14+up*1cm;
z16=z15+left*3.5cm;
z17=z16+down*1cm;
y18=y13;
x18=x1;
y20=y0r;
x20=x19;

%%%%%% MT8870 %%%%%%%%%%%
z21=z1+right*5mm+up*8mm; % anchor point
z22=z21+right*2.1cm;
z23=z22+up*1cm;
x24=x21;
y24=y23;
y25=y26=y27=y28=y29=y30=y31=y32=y33=y23;
x25=x24+1.5mm;
x26=x25+2mm;
x27=x26+2mm;
x28=x27+2mm;
x29=x28+2.5mm;
x30=x29+2.2mm;
x31=x30+1.8mm;
x32=x31+2.3mm;
x33=x32+2.9mm;
draw z21--z22--z23--z24--cycle;
label(btex MT8870 etex, 1/2[z21,z23]+down*2mm);
label.bot(btex \smallss Q1 etex, z25);
label.bot(btex \smallss Q2 etex, z26);
label.bot(btex \smallss Q3 etex, z27);
label.bot(btex \smallss Q4 etex, z28);
label.bot(btex \smallss STQ etex, z29);
label.bot(btex \smallss x etex, z30);
label.bot(btex \smallss IN etex, z31);
label.bot(btex \smallss GND etex, z32);
label.bot(btex \smallss VCC etex, z33);
%%%%%%%%%%%%%%%%%%%%%%%%%%

draw z1--z0l withpen line;
impedance0; label(btex ${}_?$ etex, 1/2[z0l,z0r]);
label(btex \vbox{
\hbox{In gorod power is 9V, not 12V, and ``?'' is 620R.}
\hbox{In home ``?'' is 560R.}
} etex, 1/2[z0l,z0r]+down*1cm);
draw z19--z2 withpen line;
draw unitsquare shifted (-.5,-.5) xscaled 3mm yscaled 3mm shifted z6;
label(btex \smallss RJ11 etex, z6);
draw unitsquare shifted (-.5,-.5) xscaled x3w yscaled x3h shifted z3 withpen line;
label(btex Analog DECT phone etex, z3);
draw z7--z11 withpen line;
label.top(btex \tt+ etex, z5); label.top(btex \tt- etex, z8);
draw unitsquare shifted (-.5,0) xscaled (abs(z5-z8)+3mm) yscaled 4mm shifted 1/2[z5,z8];
draw z9{up}..(1/2[z9,z10]+up*3mm){z10-z9}..z10{down};
label.top(btex \smallss LED etex, 1/2[z9,z10]+down*.5mm);
draw z11--z12 withpen line;
draw z12--z13 withpen line;
draw z14--z15--z16--z17--cycle;
label(btex \tt- etex, z1+left*2mm);
draw z13--z18 withpen line;
drawdot z13 withpen pencircle scaled 2pt;
label(btex \tt+ etex, z18+left*2mm);
label(btex \twlbs 12V etex, 1/2[z1,z18]+left*8mm);
draw z0r--z20 withpen line;
draw z19--z20 withpen line;
endfig;

end
