outputtemplate:="%j.eps"; prologues:=3;

input circuit;

verbatimtex
\font\big=cmss17
\font\tenss=cmss10 \tenss
\font\smallss=cmss8 scaled 400
\font\eightss=cmss8
\font\sevenss=cmss8 scaled 600
\font\twlbs=cmssbx10 scaled 1200
\font\eighttt=cmtt8
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

% RULES:
%  1) set wire relative to itself and to connection points (never relative to other wires or elements)
%  2) draw objects in the same place in file where their points are defined
%  3) bind each object to one point with absolute coordinates
%  4) define and draw wires in the end of figure (using "for" loop where applicable) with endpoints being connection points

beginfig(3);
imp:=1/2*1.5*7mm;
cap:=1/2*8mm;

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

%%%%%%%% RJ11 %%%%%%%%%%%%%%
pair rj[];
rj1=(30.5mm,-9mm);
rj2=rj1+right*3mm;
rj3=rj2+up*3mm;
xpart(rj4)=xpart(rj1); ypart(rj4)=ypart(rj3);
% pins
pair rj.plus,rj.minus;
xpart(rj.plus)=xpart(rj.minus)=xpart(rj1);
ypart(rj.plus)=ypart(rj1)+2mm;
ypart(rj.minus)=ypart(rj1)+1mm;
% draw
draw rj1--rj2--rj3--rj4--cycle;
label(btex \smallss RJ11 etex, 1/2[rj1,rj3]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%% Arduino %%%%%%%%%%%%%
pair arduino[];
arduino1=(-1.3cm,2cm);
arduino2=arduino1+right*3.3cm;
arduino3=arduino2+up*1cm;
xpart(arduino4)=xpart(arduino1);
ypart(arduino4)=ypart(arduino3);
% pins
pair arduino.B[],arduino.D[],arduino.E[],arduino.GND,arduino.VCC,arduino.RST;
xpart(arduino.B5)=xpart(arduino4)+2mm; ypart(arduino.B5)=ypart(arduino4);
xpart(arduino.B4)=xpart(arduino.B5)+3mm; ypart(arduino.B4)=ypart(arduino4);
xpart(arduino.E6)=xpart(arduino.B4)+3mm; ypart(arduino.E6)=ypart(arduino4);
xpart(arduino.D7)=xpart(arduino.E6)+3mm; ypart(arduino.D7)=ypart(arduino4);
xpart(arduino.D1)=xpart(arduino.D7)+12mm; ypart(arduino.D1)=ypart(arduino4);
xpart(arduino.GND)=xpart(arduino.D1)+5mm; ypart(arduino.GND)=ypart(arduino4);
xpart(arduino.D2)=xpart(arduino.GND)+3.5mm; ypart(arduino.D2)=ypart(arduino4);
xpart(arduino.B6)=xpart(arduino.B5); ypart(arduino.B6)=ypart(arduino1);
xpart(arduino.VCC)=xpart(arduino.D1); ypart(arduino.VCC)=ypart(arduino1);
xpart(arduino.RST)=xpart(arduino.VCC)+3mm; ypart(arduino.RST)=ypart(arduino1);
% draw
draw arduino1--arduino2--arduino3--arduino4--cycle;
label.bot(btex \smallss B5 etex, arduino.B5);
label.bot(btex \smallss B4 etex, arduino.B4);
label.bot(btex \smallss E6 etex, arduino.E6);
label.bot(btex \vbox{\hsize0pt
\centerline{\smallss 6}
\kern-7.5pt
\centerline{\smallss D7}
} etex, arduino.D7);
%draw superellipse((100pt,50pt),(50pt,100pt),(0,50pt),(50pt,0),.95); % "right\_point","top\_point","left\_point","bottom\_point",
draw unitsquare shifted (-.5,-1) xscaled 6pt yscaled 4pt shifted (arduino.D7+down*2.3mm) withpen pencircle scaled .4pt;
label.bot(btex \smallss D1 etex, arduino.D1);
label.bot(btex \smallss GND etex, arduino.GND);
label.bot(btex \smallss D2 etex, arduino.D2);
label.top(btex \smallss B6 etex, arduino.B6);
label.top(btex \smallss VCC etex, arduino.VCC);
label.top(btex \smallss RST etex, arduino.RST);
drawarrow arduino.RST--arduino.RST+down*2mm;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y20=y0r;
x20=x19;

%%%%%% MT8870 %%%%%%%%%%%
z21=z1+right*2mm+up*8mm; % anchor point
z22=z21+right*2.1cm;
z23=z22+up*1cm;
x24=x21;
y24=y23;
% pins
pair dtmf.empty;
y25=y26=y27=y28=y29=y30=y31=y32=y33=y23;
x25=x24+1.5mm;
x26=x25+2mm;
x27=x26+2mm;
x28=x27+2mm;
x29=x28+2.5mm;
xpart(dtmf.empty)=xpart(z29)+2.2mm;
ypart(dtmf.empty)=ypart(z23);
x31=xpart(dtmf.empty)+1.8mm;
x32=x31+2.3mm;
x33=x32+2.9mm;
% draw
draw z21--z22--z23--z24--cycle;
label(btex MT8870 etex, 1/2[z21,z23]+down*2mm);
label.bot(btex \smallss Q1 etex, z25);
label.bot(btex \smallss Q2 etex, z26);
label.bot(btex \smallss Q3 etex, z27);
label.bot(btex \smallss Q4 etex, z28);
label.bot(btex \smallss STQ etex, z29);
fill unitsquare shifted (-.5,-1) scaled 2.3pt shifted (dtmf.empty+down*2.8pt);
label.bot(btex \smallss IN etex, z31);
label.bot(btex \smallss GND etex, z32);
label.bot(btex \smallss VCC etex, z33);
%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%% Capacitor %%%%%%%%%%%
x34l=x12-2.3cm-2cap;
y34l=y31+5mm; % anchor point 2
z34r=z34l+(2cap,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% relay %%%%%%%%%%%%%%%
pair relay[];
relay1=(5cm,2.5cm);
relay2=relay1+right*1cm;
relay3=relay2+up*9mm;
xpart(relay4)=xpart(relay1); ypart(relay4)=ypart(relay3);
% pins
pair relay.IN, relay.GND, relay.VCC;
xpart(relay.IN)=xpart(relay1); ypart(relay.IN)=ypart(relay1)+7mm;
xpart(relay.VCC)=xpart(relay1); ypart(relay.VCC)=ypart(relay1)+5mm;
xpart(relay.GND)=xpart(relay1); ypart(relay.GND)=ypart(relay1)+3mm;
% draw
draw relay1--relay2--relay3--relay4--cycle;
label.rt(btex \smallss IN etex, relay.IN);
label.rt(btex \smallss VCC etex, relay.VCC);
label.rt(btex \smallss GND etex, relay.GND);
label(btex \vbox{\hsize0pt
  \centerline{\sevenss Relay}
  \kern-7pt
  \centerline{\smallss(normally open)}
} etex rotated 90, 1/2[relay1,relay3]+right*2mm);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%% power plug %%%%%%%%%%
z60=(6.8cm,4cm);
z61=z60+right*3mm;
z62=z61+up*7mm;
x63=x60; y63=y62;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%% PC817C %%%%%%%%%%%
z35=(3.7cm,2cm); % anchor point
z36=z35+right*6mm;
z37=z36+up*7mm;
x38=x35; y38=y37;
% pins
x39=x9; x40=x10; y39=y40=y35;
x41=x40; x42=x39; y41=y42=y37;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
draw z1--z0l ;
impedance0; label(btex ${}_?$ etex, 1/2[z0l,z0r]);
label(btex \vbox{
\hbox{In gorod power is 9V, not 12V, and ``?'' is 620R.}
\hbox{In home ``?'' is 560R.}
} etex, 1/2[z0l,z0r]+down*1cm);
draw unitsquare shifted (-.5,-.5) xscaled x3w yscaled x3h shifted z3 ;
label(btex Analog DECT phone etex, z3);
label.top(btex \tt- etex, z5); label.top(btex \tt+ etex, z8);
draw unitsquare shifted (-.5,0) xscaled (abs(z5-z8)+3mm) yscaled 4mm shifted 1/2[z5,z8];
draw z9{up}..(1/2[z9,z10]+up*3mm){z10-z9}..z10{down};
label.top(btex \smallss LED etex, 1/2[z9,z10]+down*.5mm);
label.bot(btex \eighttt+ etex, z9);
label.bot(btex \eighttt- etex, z10);

%%%%%%%%%%%% capacitor %%%%%%%%%%%%%%%%%
capacitor34(normal);
draw z31--(x31,y34l)--z34l ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

draw z35--z36--z37--z38--cycle;
draw z9--z39; draw z10--z40;
label(btex \smallss 1 etex, z39+up*1mm); label(btex \smallss 2 etex, z40+up*1mm);
label(btex \smallss PC817C etex, 1/2[z35,z37]);
label(btex \smallss 3 etex, z41+down*1mm); label(btex \smallss 4 etex, z42+down*1mm);

draw z42--(x42,ypart(arduino.D2)+1mm)--(xpart(arduino.D2),ypart(arduino.D2)+1mm)--arduino.D2;
draw z41--(x41,ypart(arduino4)+3mm+1mm)--(xpart(arduino.GND),ypart(arduino4)+3mm+1mm)--arduino.GND;
draw z32--(x32,y32+2mm)--(xpart(arduino2)+2mm,y32+2mm)--(xpart(arduino2)+2mm,ypart(arduino.GND)+2mm)--(xpart(arduino.GND),ypart(arduino.GND)+2mm)--arduino.GND;
drawdot (xpart(arduino.GND),ypart(arduino.GND)+2mm) withpen pencircle scaled 2pt;

%%%%%%%%%%%%%%% power plug %%%%%%%%%%%%%%
draw z60--z61--z62--z63--cycle;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

draw (z62+down*1mm)--(z62+down*1mm+right*2mm);
draw (z62+down*2.5mm)--(z62+down*2.5mm+right*2mm);

%----
pair wire[][];

draw z5+right*.5mm+up*4mm--(x5+.5mm,y5+2.1cm)--(xpart(relay2),y5+2.1cm);
draw (xpart(relay2),y5+2.4cm)--(x5+.5mm,y5+2.4cm)--(x5+.5mm,y60);
draw z8+left*.5mm+up*4mm--(x8-.5mm,y60);
draw z33--(x33,y33+1mm)--(xpart(arduino.VCC),y33+1mm)--(xpart(arduino.VCC),ypart(arduino.VCC)-2mm);

wire1[1]=arduino.VCC+down*3mm;
wire1[2]=wire1[1]+right*2cm;
xpart(wire1[3])=xpart(wire1[2]); ypart(wire1[3])=ypart(relay.VCC);
draw arduino.VCC -- for i=1 upto 3: wire1[i]-- endfor relay.VCC;
drawdot wire1[1] withpen pencircle scaled 2pt;

wire2[1]=relay.GND+left*5mm;
wire2[2]=wire2[1]+up*7mm;
xpart(wire2[3])=xpart(arduino.GND); ypart(wire2[3])=ypart(wire2[2]);
draw relay.GND -- for i=1 upto 3: wire2[i]-- endfor arduino.GND;

drawdot (xpart(arduino.GND),ypart(arduino4)+3mm+1mm) withpen pencircle scaled 2pt;

wire3[1]=z0r+right*12.5mm;
draw z0r..wire3[1]..controls (xpart(wire3[1])+5mm,ypart(wire3[1])) and (xpart(rj.minus)-5mm,ypart(rj.minus))..rj.minus;

xpart(wire4[1])=xpart(wire3[1]);
ypart(wire4[1])=ypart(wire4[2]);
wire4[2]=arduino.GND+up*3mm;
draw wire3[1]--wire4[1]--wire4[2]--arduino.GND;
drawdot wire3[1] withpen pencircle scaled 2pt;
drawdot wire4[2] withpen pencircle scaled 2pt;

xpart(wire5[1])=x1;
ypart(wire5[1])=ypart(rj.plus);
xpart(wire5[2])=x34r; ypart(wire5[2])=ypart(wire5[1]);
draw wire5[1]--wire5[2]--rj.plus;
drawdot wire5[2] withpen pencircle scaled 2pt;
label(btex \tt- etex, z1+left*2mm);
label(btex \tt+ etex, wire5[1]+left*2mm);
label(btex \twlbs 12V etex, 1/2[z1,wire5[1]]+left*8mm);

draw z34r--wire5[2];

draw (xpart(relay1),ypart(relay1)+7mm)--(xpart(relay1)-3mm,ypart(relay1)+7mm)--(xpart(relay1)-3mm,ypart(arduino4)+3mm+4mm)--(xpart(arduino.E6),ypart(arduino4)+3mm+4mm)--arduino.E6;

draw z25--(x25,ypart(arduino.B4)+2mm)--(xpart(arduino.B4),ypart(arduino.B4)+2mm)--arduino.B4;
draw z26--(x26,ypart(arduino.B5)+1mm)--(xpart(arduino.B5),ypart(arduino.B5)+1mm)--arduino.B5;
draw z27..controls (x27,y27+7mm) and (xpart(arduino.B6),ypart(arduino.B6)-7mm) .. arduino.B6;
draw z28--(x28,y28+2mm)--(x25-2mm,y28+2mm)--(x25-2mm,ypart(arduino.B4)+3mm)--(xpart(arduino.D7),ypart(arduino.B4)+3mm)--arduino.D7;
draw z29--(x29,y29+4mm)--(x25-4mm,y29+4mm)--(x25-4mm,ypart(arduino.B4)+5mm)--(xpart(arduino.D1),ypart(arduino.B4)+5mm)--arduino.D1;

label(btex Arduino etex, 1/2[arduino1,arduino3]);

endfig;

end
