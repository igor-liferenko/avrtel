%outputtemplate:="%j.eps"; prologues:=3;

input rboxes;

verbatimtex
\font\big=cmss17
\font\tenss=cmss10 \tenss
\font\smallss=cmss8 scaled 400
\font\eightss=cmss8
\font\sevenandhalfss=cmss8 scaled 900
\font\sevenss=cmss8 scaled 600
\font\twlss=cmss12
\font\eighttt=cmtt8
etex

vardef cutl(suffix a, b) =
draw a.c -- b.c cutbefore bpath.a cutafter bpath.b;
enddef;

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

beginfig(1);

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
relay1=(6.2cm,2.5cm);
relay2=relay1+right*3mm;
relay3=relay2+up*9mm;
xpart(relay4)=xpart(relay1); ypart(relay4)=ypart(relay3);
% pins
pair relay.IN, relay.GND, relay.load[];
xpart(relay.IN)=xpart(relay4)+2mm; ypart(relay.IN)=ypart(relay4);
xpart(relay.GND)=xpart(relay4)+1mm; ypart(relay.GND)=ypart(relay4);
xpart(relay.load1)=xpart(relay2); ypart(relay.load1)=ypart(relay2)+5.5mm;
xpart(relay.load2)=xpart(relay2); ypart(relay.load2)=ypart(relay2)+4mm;
% draw
draw relay1--relay2--relay3--relay4--cycle;
label(btex \smallss SHARP S202S02 etex rotated 90, 1/2[relay1,relay3]);
label(btex \smallss 220V etex rotated 90, 1/2[relay.load1,relay.load2]+right*4mm);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pair linepower.plus, linepower.minus;
linepower.plus=(-17mm,-5mm);
linepower.minus=linepower.plus+down*3mm;

%%%%%%%%%%%%%%% power plug %%%%%%%%%%%%%%
pair powerplug[], powerplug.minus, powerplug.plus;
powerplug1=(5.5cm,2.45cm);
powerplug2=powerplug1+right*3mm;
powerplug3=powerplug2+up*7mm;
xpart(powerplug4)=xpart(powerplug1); ypart(powerplug4)=ypart(powerplug3);
% pins
powerplug.minus=powerplug1+right*1mm;
powerplug.plus=powerplug2+left*1mm;
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

%----

path wire[];
pair wire[][];

wire2[1]=relay.GND+up*1mm;
xpart(wire2[2])=xpart(wire2[1]);
ypart(wire2[2])=ypart(wire2[3]);
wire2[3]=arduino.GND1+up*5mm;
draw relay.GND -- for i=1 upto 3: wire2[i]-- endfor arduino.GND1;

wire4[1]=arduino.GND1+up*4mm;
wire4[2]=wire4[1]+right*14mm;
wire4[3]=(xpart(wire4[2]),ypart(linepower.plus));
draw arduino.GND1--wire4[1]--wire4[2]--wire4[3];

wire5[1]=dtmf.IN+up*4mm;
wire5[2]=wire5[1]+right*8.5mm;
xpart(wire5[3])=xpart(wire5[2]);
ypart(wire5[3])=ypart(linepower.plus);
draw dtmf.IN -- wire5[1] --  wire5[2] -- wire5[3];

boxit.resistor();
resistor.c=1/2[wire5[3],wire4[3]];
resistor.e-resistor.w=right*8mm;
resistor.n-resistor.s=up*3mm;
drawboxed(resistor);

label.lft(btex \sevenandhalfss Adjust resistor to measure $\approx$4.3V on it when off-hook. etex, phone.sw+up*1mm);

draw linepower.minus--(xpart(phone.w),ypart(linepower.minus));
draw linepower.plus -- resistor.w;
draw resistor.e -- (xpart(phone.w),ypart(linepower.plus));
label(btex \tt- etex, linepower.minus+left*2mm);
label(btex \tt+ etex, linepower.plus+left*2mm);
label(btex $\approx$\twlss 12V etex, 1/2[linepower.minus,linepower.plus]+left*8mm);
label.rt(btex \eightss RJ11 etex rotated -90, (xpart(phone.w),ypart(1/2[linepower.plus,linepower.minus])));

draw relay.load1--relay.load1+right*2mm;
draw relay.load2--relay.load2+right*2mm;
draw powerplug.minus -- (xpart(powerplug.minus),ypart(phone.n));
draw powerplug.plus--(xpart(powerplug.plus),ypart(phone.n));

wire6[1]=dtmf.VCC+up*7mm;
xpart(wire6[2])=xpart(arduino.VCC);
ypart(wire6[2])=ypart(wire6[1]);
draw dtmf.VCC -- for i=1 upto 2: wire6[i]-- endfor arduino.VCC;

wire7[1]=dtmf.GND+up*2mm;
wire7[2]=wire7[1]+right*24mm;
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

wire13[1]=relay.IN+up*1mm;
xpart(wire13[2])=xpart(wire13[1]);
ypart(wire13[2])=ypart(wire13[3]);
wire13[3]=arduino.E6+up*6mm;
draw relay.IN -- for i=1 upto 3: wire13[i]-- endfor arduino.E6;

wire14[1]=arduino.D2+up*2mm;
xpart(wire14[2])=xpart(wire14[1])+6mm; ypart(wire14[2])=ypart(wire14[1]);
xpart(wire14[3])=xpart(wire14[2]); ypart(wire14[3])=ypart(wire14[2])-25mm;
xpart(wire14[4])=xpart(wire14[3]); ypart(wire14[4])=ypart(wire14[5]);
wire14[5]=wire5[3]+right*.7mm+up*17mm;
xpart(wire14[6])=xpart(wire14[5]); ypart(wire14[6])=ypart(wire5[3]);
draw arduino.D2 -- wire14[1] -- wire14[2] -- wire14[3] -- wire14[4] -- wire14[5] -- wire14[6];

endfig;

end
