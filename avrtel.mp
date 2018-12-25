%outputtemplate:="%j.eps"; prologues:=3;

input circuit;
input rboxes;

verbatimtex
\font\big=cmss17
\font\tenss=cmss10 \tenss
\font\smallss=cmss8 scaled 400
\font\eightss=cmss8
\font\sevenss=cmss8 scaled 600
\font\twlbs=cmssbx10 scaled 1200
\font\eighttt=cmtt8
etex

vardef cutl(suffix a, b) =
draw a.c -- b.c cutbefore bpath.a cutafter bpath.b;
enddef;

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
%%%%%% TODO: do like this
circleit.circ1(btex \big ep0 etex);
circ1.n-circ1.c=up*r; circ1.e-circ1.c=right*r;
circ1.c=(0,0);
drawboxed(circ1);
circleit.circ2(btex \big ep8 etex);
circ2.n-circ2.c=up*r; circ2.e-circ2.c=right*r;
circ2.c=(.5cm,3cm);
drawboxed(circ2);
cutl(circ1,circ2);
%%%%%%%%%%%%
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

% TODO: put pullup inside the MCU box
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

% TODO: do boxes with 4 corners via "boxit", like "phone" (use "drawboxes(box4); draw pic(box4) shifted (0,-1cm);" to position label not in center)

vardef piggyback(expr p) =
save A,u; pair A,u;
u := unitvector(p-(xpart(p),ypart(1/2[arduino1,arduino3])));
A := p+u*1.5mm;
draw p -- A withpen pencircle scaled .4pt;
draw (A - 2pt*u rotated 20) -- A -- (A - 2pt*u rotated -20) withpen pencircle scaled .4pt;
enddef;

beginfig(3);
imp:=1/2*1.5*7mm;
cap:=1/2*8mm;

z0l=(0,-10mm);
z0r=z0l+right*2imp;

%%%%%%%%% Arduino %%%%%%%%%%%%%
pair arduino[];
arduino1=(-1.3cm,2cm);
arduino2=arduino1+right*3.3cm;
arduino3=arduino2+up*1.5cm;
xpart(arduino4)=xpart(arduino1);
ypart(arduino4)=ypart(arduino3);
% pins
pair arduino.B[],arduino.D[],arduino.E[],arduino.GND[],arduino.VCC,arduino.RST,arduino.TX[];
xpart(arduino.B5)=xpart(arduino4)+2mm; ypart(arduino.B5)=ypart(arduino4);
xpart(arduino.B4)=xpart(arduino.B5)+3mm; ypart(arduino.B4)=ypart(arduino4);
xpart(arduino.E6)=xpart(arduino.B4)+3mm; ypart(arduino.E6)=ypart(arduino4);
xpart(arduino.D7)=xpart(arduino.E6)+3mm; ypart(arduino.D7)=ypart(arduino4);
xpart(arduino.D1)=xpart(arduino.D7)+8mm; ypart(arduino.D1)=ypart(arduino4);
xpart(arduino.GND1)=xpart(arduino.D1)+3mm; ypart(arduino.GND1)=ypart(arduino4);
xpart(arduino.GND2)=xpart(arduino.GND1)+3mm; ypart(arduino.GND2)=ypart(arduino4);
xpart(arduino.D2)=xpart(arduino.GND2)+3mm; ypart(arduino.D2)=ypart(arduino4);
xpart(arduino.TX0)=xpart(arduino.D2)+2.85mm; ypart(arduino.TX0)=ypart(arduino4);
xpart(arduino.B6)=xpart(arduino.B5); ypart(arduino.B6)=ypart(arduino1);
xpart(arduino.16)=xpart(arduino.B4); ypart(arduino.16)=ypart(arduino1);
xpart(arduino.14)=xpart(arduino.E6); ypart(arduino.14)=ypart(arduino1);
xpart(arduino.15)=xpart(arduino.D7); ypart(arduino.15)=ypart(arduino1);
xpart(arduino.VCC)=xpart(arduino.D1); ypart(arduino.VCC)=ypart(arduino1);
xpart(arduino.RST)=xpart(arduino.GND2); ypart(arduino.RST)=ypart(arduino1);
xpart(arduino.GND3)=xpart(arduino.D2); ypart(arduino.GND3)=ypart(arduino1);
% draw
draw arduino1--arduino2--arduino3--arduino4--cycle;
label(btex \eightss Arduino ProMicro etex, 1/2[arduino1,arduino3]);
begingroup;
save A; pen A; A:=currentpen;
pickup pencircle scaled .4pt;
boxit.arduino.B0.box(btex \smallss B0 etex);
arduino.B0.box.c=1/2[arduino.B4,arduino.B5]+down*5.5mm;
arduino.B0.box.sw=arduino.B0.box.c+down*2pt+left*3pt; % TODO: use sw and ne corners to specify full width and height, like in setup-tarif.mp, use rbox_radius, use thinner line for drawing the box
drawboxed(arduino.B0.box);
boxit.arduino.D5.box(btex \smallss D5 etex);
arduino.D5.box.c=(xpart(arduino.B0.box.c),ypart(arduino1)+5.5mm);
arduino.D5.box.sw=arduino.D5.box.c+down*2pt+left*3pt;
drawboxed(arduino.D5.box);
label.bot(btex \smallss 9 etex, arduino.B5);
rboxit.arduino.B5.box(btex \smallss B5 etex);
arduino.B5.box.c=arduino.B5+down*3mm;
arduino.B5.box.sw=arduino.B5.box.c+down*2pt+left*3pt;
drawboxed(arduino.B5.box);
label.bot(btex \smallss 8 etex, arduino.B4);
rboxit.arduino.B4.box(btex \smallss B4 etex);
arduino.B4.box.c=arduino.B4+down*3mm;
arduino.B4.box.sw=arduino.B4.box.c+down*2pt+left*3pt;
drawboxed(arduino.B4.box);
label.bot(btex \smallss 7 etex, arduino.E6);
rboxit.arduino.E6.box(btex \smallss E6 etex);
arduino.E6.box.c=arduino.E6+down*3mm;
arduino.E6.box.sw=arduino.E6.box.c+down*2pt+left*3pt;
drawboxed(arduino.E6.box);
label.bot(btex \smallss 6 etex, arduino.D7);
rboxit.arduino.D7.box(btex \smallss D7 etex);
arduino.D7.box.c=arduino.D7+down*3mm;
arduino.D7.box.sw=arduino.D7.box.c+down*2pt+left*3pt;
drawboxed(arduino.D7.box);
label.bot(btex \smallss 2 etex, arduino.D1);
rboxit.arduino.D1.box(btex \smallss D1 etex);
arduino.D1.box.c=arduino.D1+down*3mm;
arduino.D1.box.sw=arduino.D1.box.c+down*2pt+left*3pt;
drawboxed(arduino.D1.box);
label.bot(btex \smallss GND etex, arduino.GND1);
label.bot(btex \smallss GND etex, arduino.GND2);
piggyback(arduino.GND2);
label.bot(btex \smallss RX1 etex, arduino.D2);
rboxit.arduino.D2.box(btex \smallss D2 etex);
arduino.D2.box.c=arduino.D2+down*3mm;
arduino.D2.box.sw=arduino.D2.box.c+down*2pt+left*3pt;
drawboxed(arduino.D2.box);
label.bot(btex \smallss TX0 etex, arduino.TX0);
piggyback(arduino.TX0);
label.top(btex \smallss 10 etex, arduino.B6);
rboxit.arduino.B6.box(btex \smallss B6 etex);
arduino.B6.box.c=arduino.B6+up*3mm;
arduino.B6.box.sw=arduino.B6.box.c+down*2pt+left*3pt;
drawboxed(arduino.B6.box);
label.top(btex \smallss 16 etex, arduino.16);
piggyback(arduino.16);
label.top(btex \smallss 14 etex, arduino.14);
piggyback(arduino.14);
label.top(btex \smallss 15 etex, arduino.15);
piggyback(arduino.15);
label.top(btex \smallss VCC etex, arduino.VCC);
label.top(btex \smallss RST etex, arduino.RST);
piggyback(arduino.RST);
label.top(btex \smallss GND etex, arduino.GND3);
piggyback(arduino.GND3);
pickup A;
endgroup;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y20=y0r;
x20=x19;

%%%%%% MT8870 %%%%%%%%%%%
pair dtmf[];
dtmf1=(-18mm,-2mm);
dtmf2=dtmf1+right*2.1cm;
dtmf3=dtmf2+up*1cm;
xpart(dtmf4)=xpart(dtmf1);
ypart(dtmf4)=ypart(dtmf3);
% pins
pair dtmf.empty,dtmf.VCC,dtmf.Q[],dtmf.STQ,dtmf.IN,dtmf.GND;
xpart(dtmf.Q1)=xpart(dtmf4)+1.5mm;
ypart(dtmf.Q1)=ypart(dtmf3);
xpart(dtmf.Q2)=xpart(dtmf.Q1)+2mm;
ypart(dtmf.Q2)=ypart(dtmf3);
xpart(dtmf.Q3)=xpart(dtmf.Q2)+2mm;
ypart(dtmf.Q3)=ypart(dtmf3);
xpart(dtmf.Q4)=xpart(dtmf.Q3)+2mm;
ypart(dtmf.Q4)=ypart(dtmf3);
xpart(dtmf.STQ)=xpart(dtmf.Q4)+2.5mm;
ypart(dtmf.STQ)=ypart(dtmf3);
xpart(dtmf.empty)=xpart(dtmf.STQ)+2.2mm;
ypart(dtmf.empty)=ypart(dtmf3);
xpart(dtmf.IN)=xpart(dtmf.empty)+1.8mm;
ypart(dtmf.IN)=ypart(dtmf3);
xpart(dtmf.GND)=xpart(dtmf.IN)+2.3mm;
ypart(dtmf.GND)=ypart(dtmf3);
xpart(dtmf.VCC)=xpart(dtmf.GND)+2.9mm;
ypart(dtmf.VCC)=ypart(dtmf3);
% draw
draw dtmf1--dtmf2--dtmf3--dtmf4--cycle;
label(btex MT8870 etex, 1/2[dtmf1,dtmf3]+down*2mm);
label.bot(btex \smallss Q1 etex, dtmf.Q1);
label.bot(btex \smallss Q2 etex, dtmf.Q2);
label.bot(btex \smallss Q3 etex, dtmf.Q3);
label.bot(btex \smallss Q4 etex, dtmf.Q4);
label.bot(btex \smallss STQ etex, dtmf.STQ);
fill unitsquare shifted (-.5,-1) scaled 2.3pt shifted (dtmf.empty+down*2.8pt);
label.bot(btex \smallss IN etex, dtmf.IN);
label.bot(btex \smallss GND etex, dtmf.GND);
label.bot(btex \smallss VCC etex, dtmf.VCC);
%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% relay %%%%%%%%%%%%%%%
pair relay[];
relay1=(5cm,2.5cm);
relay2=relay1+right*1cm;
relay3=relay2+up*9mm;
xpart(relay4)=xpart(relay1); ypart(relay4)=ypart(relay3);
% pins
pair relay.IN, relay.GND, relay.VCC, relay.load[];
xpart(relay.IN)=xpart(relay1); ypart(relay.IN)=ypart(relay1)+7mm;
xpart(relay.VCC)=xpart(relay1); ypart(relay.VCC)=ypart(relay1)+5mm;
xpart(relay.GND)=xpart(relay1); ypart(relay.GND)=ypart(relay1)+3mm;
xpart(relay.load1)=xpart(relay2); ypart(relay.load1)=ypart(relay2)+6mm;
xpart(relay.load2)=xpart(relay2); ypart(relay.load2)=ypart(relay2)+3mm;
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

%%%%%%%%% PC817C %%%%%%%%%%%
pair opto[];
opto1=(3.7cm,2cm);
opto2=opto1+right*6mm;
opto3=opto2+up*7mm;
xpart(opto4)=xpart(opto1); ypart(opto4)=ypart(opto3);
% pins
pair opto.pin[];
xpart(opto.pin1)=xpart(opto1)+1.5mm;
ypart(opto.pin1)=ypart(opto1);
xpart(opto.pin2)=xpart(opto2)-1.5mm;
ypart(opto.pin2)=ypart(opto1);
xpart(opto.pin3)=xpart(opto.pin2);
ypart(opto.pin3)=ypart(opto3);
xpart(opto.pin4)=xpart(opto.pin1);
ypart(opto.pin4)=ypart(opto3);
% draw
draw opto1--opto2--opto3--opto4--cycle;
label(btex \smallss 1 etex, opto.pin1+up*1mm); label(btex \smallss 2 etex, opto.pin2+up*1mm);
label(btex \smallss PC817C etex, 1/2[opto1,opto3]);
label(btex \smallss 3 etex, opto.pin3+down*1mm); label(btex \smallss 4 etex, opto.pin4+down*1mm);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

impedance0; label(btex ${}_?$ etex, 1/2[z0l,z0r]);
label(btex \vbox{
\hbox{In gorod power is 9V, not 12V, and ``?'' is 620R.}
\hbox{In home ``?'' is 560R.}
} etex, 1/2[z0l,z0r]+down*1cm);

%%%%%%%%%%%%%%% power plug %%%%%%%%%%%%%%
pair powerplug[], powerplug.minus, powerplug.plus;
powerplug1=(6.8cm,4cm);
powerplug2=powerplug1+right*3mm;
powerplug3=powerplug2+up*7mm;
xpart(powerplug4)=xpart(powerplug1); ypart(powerplug4)=ypart(powerplug3);
% pins
powerplug.minus=powerplug1+right*.5mm;
powerplug.plus=powerplug2+left*.5mm;
% draw
draw powerplug1--powerplug2--powerplug3--powerplug4--cycle;
draw (powerplug3+down*1mm)--(powerplug3+down*1mm+right*2mm);
draw (powerplug3+down*2.5mm)--(powerplug3+down*2.5mm+right*2mm);
label(btex \vbox{\hsize0pt
\centerline{\smallss power}
\kern-8.8pt
\centerline{\smallss supply}
} etex rotated 90, 1/2[powerplug1,powerplug3]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%% phone %%%%%%%%%%%%%%%
boxit.phone(btex Analog DECT phone etex);
phone.c=(5.3cm,-1mm);
phone.e-phone.w=right*3.9cm;
phone.n-phone.s=up*2.4cm;
drawboxed(phone);
label.bot(btex \eighttt-+ etex, (xpart(1/2[powerplug.minus,powerplug.plus]),ypart(phone.n)));
label.bot(btex \eighttt+\eightss LED\eighttt- etex, (xpart(1/2[opto.pin1,opto.pin2]),ypart(phone.n))+down*.25mm);

pair linepower.plus, linepower.minus;
linepower.minus=z0l+left*2cm;
linepower.plus=linepower.minus+up*3mm;

%----
draw linepower.plus--(xpart(phone.w),ypart(linepower.plus));
label(btex \tt- etex, linepower.minus+left*2mm);
label(btex \tt+ etex, linepower.plus+left*2mm);
label(btex \twlbs 12V etex, 1/2[linepower.minus,linepower.plus]+left*8mm);
draw linepower.minus--z0l;
draw z0r--(xpart(phone.w),ypart(z0r));
label.rt(btex \eightss RJ11 etex rotated -90, (xpart(phone.w),ypart(1/2[linepower.plus,linepower.minus])));

path wire[];
pair wire[][];

wire1[1]=arduino.VCC+down*2mm;
wire1[2]=wire1[1]+right*2cm;
xpart(wire1[3])=xpart(wire1[2]); ypart(wire1[3])=ypart(relay.VCC);
draw arduino.VCC -- for i=1 upto 3: wire1[i]-- endfor relay.VCC;

wire2[1]=relay.GND+left*5mm;
xpart(wire2[2])=xpart(wire2[1]);
ypart(wire2[2])=ypart(wire2[3]);
wire2[3]=arduino.GND1+up*6mm;
draw relay.GND -- for i=1 upto 3: wire2[i]-- endfor arduino.GND1;

wire4[1]=arduino.GND1+up*4mm;
wire4[2]=wire4[1]+right*14mm;
wire4[3]=(xpart(wire4[2]),ypart(z0r));
draw arduino.GND1--wire4[1]--wire4[2]--wire4[3];

wire5[1]=dtmf.IN+up*5mm;
wire10[1]=wire5[1]+right*8.5mm;
z34l=1/2[wire5[1],wire10[1]]-(cap,0);
z34r=z34l+(2cap,0);
capacitor34(normal);
label.top(btex \eightss ??? etex, 1/2[z34l,z34r]+up*1mm);
xpart(wire10[2])=xpart(wire10[1]);
ypart(wire10[2])=ypart(linepower.plus);
draw dtmf.IN -- wire5[1] -- z34l;
draw z34r -- wire10[1] -- wire10[2];

draw relay.load1--(xpart(powerplug.minus),ypart(relay.load1))--powerplug.minus;
draw (xpart(powerplug.minus),ypart(phone.n))--(xpart(powerplug.minus),ypart(relay.load2))--relay.load2;
draw powerplug.plus--(xpart(powerplug.plus),ypart(phone.n));

wire6[1]=dtmf.VCC+up*1mm;
xpart(wire6[2])=xpart(arduino.VCC);
ypart(wire6[2])=ypart(wire6[1]);
draw dtmf.VCC -- for i=1 upto 2: wire6[i]-- endfor arduino.VCC;

wire7[1]=dtmf.GND+up*2mm;
wire7[2]=wire7[1]+right*23mm;
xpart(wire7[3])=xpart(wire7[2]);
ypart(wire7[3])=ypart(wire7[4]);
wire7[4]=arduino.GND1+up*3mm;
draw dtmf.GND -- for i=1 upto 4: wire7[i]-- endfor arduino.GND1;

wire8[1]=dtmf.STQ+up*4mm;
wire8[2]=wire8[1]+left*12.5mm;
xpart(wire8[3])=xpart(wire8[2]);
ypart(wire8[3])=ypart(wire8[4]);
wire8[4]=arduino.D1+up*4mm;
draw dtmf.STQ -- for i=1 upto 4: wire8[i]-- endfor arduino.D1;

wire9[1]=dtmf.Q4+up*2mm;
wire9[2]=wire9[1]+left*8mm;
xpart(wire9[3])=xpart(wire9[2]);
ypart(wire9[3])=ypart(wire9[4]);
wire9[4]=arduino.D7+up*3mm;
draw dtmf.Q4 -- for i=1 upto 4: wire9[i]-- endfor arduino.D7;

draw dtmf.Q3 .. controls (xpart(dtmf.Q3),ypart(dtmf.Q3)+7mm) and (xpart(arduino.B6),ypart(arduino.B6)-7mm) .. arduino.B6;

xpart(wire11[1])=xpart(dtmf.Q2);
ypart(wire11[1])=ypart(wire11[2]);
wire11[2]=arduino.B5+up*1mm;
draw dtmf.Q2 -- wire11[1] -- wire11[2] -- arduino.B5;

xpart(wire12[1])=xpart(dtmf.Q1);
ypart(wire12[1])=ypart(wire12[2]);
wire12[2]=arduino.B4+up*2mm;
draw dtmf.Q1 -- wire12[1] -- wire12[2] -- arduino.B4;

wire13[1]=relay.IN+left*3mm;
xpart(wire13[2])=xpart(wire13[1]);
ypart(wire13[2])=ypart(wire13[3]);
wire13[3]=arduino.E6+up*7mm;
draw relay.IN -- for i=1 upto 3: wire13[i]-- endfor arduino.E6;

draw (xpart(opto.pin1),ypart(phone.n))--opto.pin1;
draw (xpart(opto.pin2),ypart(phone.n))--opto.pin2;

wire14[1]=arduino.D2+up*2mm;
xpart(wire14[2])=xpart(opto.pin4);
ypart(wire14[2])=ypart(wire14[1]);
draw arduino.D2 -- wire14[1] -- wire14[2] -- opto.pin4;

wire15[1]=arduino.GND1+up*5mm;
xpart(wire15[2])=xpart(opto.pin3);
ypart(wire15[2])=ypart(wire15[1]);
draw arduino.GND1 -- wire15[1] -- wire15[2] -- opto.pin3;

endfig;

end
