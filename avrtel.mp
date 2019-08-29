%outputtemplate:="%j.eps"; prologues:=3; fontmapfile "pdftex.map";

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

% RULES:
%  1) set wire relative to itself and to connection points (never relative to other wires or elements)
%  2) draw objects in the same place in file where their points are defined
%  3) bind each object to one point with absolute coordinates
%  4) define and draw wires in the end of figure (using "for" loop where applicable) with endpoints being connection points

beginfig(1);
u:=1cm;

%%%%%%%%% Arduino %%%%%%%%%%%%%
boxit.arduino(btex \eightss Arduino Micro etex);
arduino.c=(-.9u,3u);
arduino.e-arduino.w=right*4cm;
arduino.n-arduino.s=up*1.4cm;
drawboxes(arduino); draw pic(arduino) shifted (up*2mm+left*6mm);
% pins
pair arduino.B[],arduino.D[],arduino.C[],arduino.E[],arduino.GND[],arduino.VCC;
arduino.B6=arduino.se+left*6.75mm;
arduino.B5=arduino.B6+left*2.5mm;
arduino.B4=arduino.B5+left*2.5mm;
arduino.E6=arduino.B4+left*2.5mm;
arduino.D7=arduino.E6+left*2.5mm;
arduino.D2=arduino.sw+right*9.25mm;
arduino.D3=arduino.D2+left*2.5mm;
arduino.D1=arduino.D2+right*7.5mm;
xpart(arduino.GND1)=xpart(arduino.D2); ypart(arduino.GND1)=ypart(arduino.n);
arduino.VCC=arduino.GND1+right*5mm;
xpart(arduino.GND2)=xpart(arduino.VCC); ypart(arduino.GND2)=ypart(arduino.s);
% draw
begingroup;
interim rbox_radius:=1bp;
save A; pen A; A:=currentpen;
pickup pencircle scaled .1pt;
boxit.arduino.C7_box(btex \smallss C7 etex);
arduino.C7_box.e=arduino.e+left*5mm+up*2mm;
arduino.C7_box.ne=arduino.C7_box.sw+right*6pt+up*4pt;
drawboxed(arduino.C7_box);
boxit.arduino.B0_box(btex \smallss B0 etex);
arduino.B0_box.e=arduino.C7_box.w+left*.5mm;
arduino.B0_box.ne=arduino.B0_box.sw+right*6pt+up*4pt;
drawboxed(arduino.B0_box);
boxit.arduino.D5_box(btex \smallss D5 etex);
arduino.D5_box.n=arduino.C7_box.s+down*.5mm;
arduino.D5_box.ne=arduino.D5_box.sw+right*6pt+up*4pt;
drawboxed(arduino.D5_box);
label.top(btex \smallss 10 etex, arduino.B6);
rboxit.arduino.B6_box(btex \smallss B6 etex);
arduino.B6_box.s=arduino.B6+up*2.3mm;
arduino.B6_box.ne=arduino.B6_box.sw+right*6pt+up*4pt;
drawboxed(arduino.B6_box);
label.top(btex \smallss TX etex, arduino.D3);
label.top(btex \smallss 9 etex, arduino.B5);
rboxit.arduino.B5_box(btex \smallss B5 etex);
arduino.B5_box.s=arduino.B5+up*2.3mm;
arduino.B5_box.ne=arduino.B5_box.sw+right*6pt+up*4pt;
drawboxed(arduino.B5_box); % TODO: do the rest like this (variable name + box dimensions)
label.top(btex \smallss 8 etex, arduino.B4);
rboxit.arduino.B4.box(btex \smallss B4 etex);
arduino.B4.box.c=arduino.B4+up*3mm;
arduino.B4.box.sw=arduino.B4.box.c+down*2pt+left*3pt;
drawboxed(arduino.B4.box);
label.top(btex \smallss 7 etex, arduino.E6);
rboxit.arduino.E6.box(btex \smallss E6 etex);
arduino.E6.box.c=arduino.E6+up*3mm;
arduino.E6.box.sw=arduino.E6.box.c+down*2pt+left*3pt;
drawboxed(arduino.E6.box);
label.top(btex \smallss 6 etex, arduino.D7);
rboxit.arduino.D7.box(btex \smallss D7 etex);
arduino.D7.box.c=arduino.D7+up*3mm;
arduino.D7.box.sw=arduino.D7.box.c+down*2pt+left*3pt;
drawboxed(arduino.D7.box);
label.top(btex \smallss RX etex, arduino.D2);
rboxit.arduino.D2.box(btex \smallss D2 etex);
arduino.D2.box.c=arduino.D2+up*3mm;
arduino.D2.box.sw=arduino.D2.box.c+down*2pt+left*3pt;
drawboxed(arduino.D2.box);
label.top(btex \smallss 2 etex, arduino.D1);
rboxit.arduino.D1.box(btex \smallss D1 etex);
arduino.D1.box.c=arduino.D1+up*3mm;
arduino.D1.box.sw=arduino.D1.box.c+down*2pt+left*3pt;
drawboxed(arduino.D1.box);
label.bot(btex \smallss GND etex, arduino.GND1);
label.bot(btex \smallss VCC etex, arduino.VCC);
label.top(btex \smallss GND etex, arduino.GND2);
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
boxit.relay(btex \smallss TLP281 etex);
relay.c=(1.65u,2.8u);
relay.e-relay.w=right*.5u;
relay.n-relay.s=up*.5u;
drawboxed(relay);
% pins
pair relay.IN, relay.GND, relay.load[];
xpart(relay.IN)=xpart(relay.w); ypart(relay.IN)=ypart(relay.c+down*.1u);
xpart(relay.GND)=xpart(relay.w); ypart(relay.GND)=ypart(relay.c+up*.1u);
xpart(relay.load1)=xpart(relay.se); ypart(relay.load1)=ypart(relay.se)+5.5mm;
xpart(relay.load2)=xpart(relay.se); ypart(relay.load2)=ypart(relay.se)+4mm;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pair linepower.plus, linepower.minus;
linepower.plus=(-17mm,-5mm);
linepower.minus=linepower.plus+down*3mm;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%% phone %%%%%%%%%%%%%%%
boxit.phone(btex \vbox{\hsize0pt
  \centerline{Analog DECT phone}
  \centerline{\sevenandhalfss (ensure that tone}
  \centerline{\sevenandhalfss \kern7pt mode is enabled)}
  } etex);
ypart(phone.n)=1.1cm;
xpart(phone.w)=4cm;
phone.e-phone.w=right*3.25cm;
phone.n-phone.s=up*2.4cm;
drawboxed(phone);

boxit.optron(btex \sevenss PC817 etex);
xpart(optron.w)=2.86cm;
ypart(optron.n)=.5cm;
optron.e-optron.w=right*.55cm;
optron.n-optron.s=up*.7cm;
drawboxed(optron);
draw fullcircle scaled 2pt shifted (optron.sw+up*1mm+right*1mm) withpen pencircle scaled .1pt;
%----

path wire[];
pair wire[][];

wire1[1]=optron.sw+right*1mm;
xpart(wire1[2])=xpart(wire1[1]);
ypart(wire1[2])=ypart(linepower.plus);
draw wire1[1] -- wire1[2];

wire3[1]=optron.se+left*1mm;
xpart(wire3[2])=xpart(wire3[1]);
ypart(wire3[2])=ypart(linepower.plus);
draw wire3[1] -- wire3[2];

wire2[1]=relay.GND+left*.1u;
xpart(wire2[2])=xpart(wire2[1]);
ypart(wire2[2])=ypart(wire2[3]);
wire2[3]=arduino.GND1+up*.2u;
draw relay.GND -- for i=1 upto 3: wire2[i]-- endfor arduino.GND1;

wire4[1]=arduino.GND1+up*5mm;
xpart(wire4[2])=xpart(optron.e+left*1mm); ypart(wire4[2])=ypart(wire4[1]);
xpart(wire4[3])=xpart(wire4[2]); ypart(wire4[3])=ypart(optron.n);
draw arduino.GND1--wire4[1]--wire4[2]--wire4[3];

wire5[1]=dtmf.IN+up*.35u;
wire5[2]=wire5[1]+right*8.5mm;
xpart(wire5[3])=xpart(wire5[2]);
ypart(wire5[3])=ypart(linepower.plus);
draw dtmf.IN -- wire5[1] --  wire5[2] -- wire5[3];

boxit.resistor();
resistor.c=1/2[wire5[3],(xpart(dtmf.GND+up*2mm+right*25mm),ypart(linepower.plus))];
resistor.e-resistor.w=right*8mm;
resistor.n-resistor.s=up*3mm;
drawboxed(resistor);

draw linepower.minus--(xpart(phone.w),ypart(linepower.minus));
draw linepower.plus -- resistor.w;
draw resistor.e -- wire1[2];
draw wire3[2] -- (xpart(phone.w),ypart(linepower.plus));
label(btex \tt- etex, linepower.minus+left*2mm);
label(btex \tt+ etex, linepower.plus+left*2mm);
label(btex $\approx$\twlss 12V etex, 1/2[linepower.minus,linepower.plus]+left*8mm);
label.rt(btex \eightss RJ11 etex rotated -90, (xpart(phone.w),ypart(1/2[linepower.plus,linepower.minus])));

wire6[1]=dtmf.VCC+up*.5u;
wire6[2]=wire6[1]+right*2u;
wire6[4]=arduino.VCC+up*.1u;
xpart(wire6[3])=xpart(wire6[2]); ypart(wire6[3])=ypart(wire6[4]);
draw dtmf.VCC -- for i=1 upto 4: wire6[i]-- endfor arduino.VCC;

wire7[1]=dtmf.GND+up*2mm;
wire7[2]=wire7[1]+right*24mm;
xpart(wire7[3])=xpart(wire7[2]);
ypart(wire7[3])=ypart(wire7[4]);
wire7[4]=arduino.GND1+up*3mm;
draw dtmf.GND -- for i=1 upto 4: wire7[i]-- endfor arduino.GND1;

xpart(wire15[1])=xpart(wire15[2]); ypart(wire15[1])=ypart(linepower.plus);
wire15[2]=dtmf.GND+up*2mm+right*25mm;
xpart(wire15[3])=xpart(wire15[2]); ypart(wire15[3])=ypart(arduino.GND1+up*4mm);
wire15[4]=arduino.GND1+up*4mm;
draw wire15[1] -- wire15[2] -- wire15[3] -- wire15[4];

wire8[1]=dtmf.STQ+up*.7u;
xpart(wire8[2])=xpart(arduino.D1+down*.6u); ypart(wire8[2])=ypart(wire8[1]);
draw dtmf.STQ -- for i=1 upto 2: wire8[i]-- endfor arduino.D1;

wire9[1]=dtmf.Q4+up*2mm;
xpart(wire9[2])=xpart(arduino.D7); ypart(wire9[2])=ypart(wire9[1]);
draw dtmf.Q4 -- for i=1 upto 2: wire9[i]-- endfor arduino.D7;

wire10[1]=dtmf.Q3+up*.6u;
xpart(wire10[2])=xpart(arduino.B6); ypart(wire10[2])=ypart(wire10[1]);
draw dtmf.Q3 -- for i=1 upto 2: wire10[i]-- endfor arduino.B6;

xpart(wire11[1])=xpart(dtmf.Q2);
ypart(wire11[1])=ypart(wire11[2]);
wire11[2]=arduino.B5+down*.1u;
draw dtmf.Q2 -- wire11[1] -- wire11[2] -- arduino.B5;

xpart(wire12[1])=xpart(dtmf.Q1);
ypart(wire12[1])=ypart(wire12[2]);
wire12[2]=arduino.B4+down*.6u;
draw dtmf.Q1 -- wire12[1] -- wire12[2] -- arduino.B4;

wire13[1]=relay.IN+left*.1u;
xpart(wire13[2])=xpart(wire13[1]);
ypart(wire13[2])=ypart(wire13[3]);
wire13[3]=arduino.E6+down*.2u;
draw relay.IN -- for i=1 upto 3: wire13[i]-- endfor arduino.E6;

wire14[1]=arduino.D2+down*.4u;
xpart(wire14[2])=xpart(optron.w+right*1mm); ypart(wire14[2])=ypart(wire14[1]);
xpart(wire14[3])=xpart(wire14[2]); ypart(wire14[3])=ypart(optron.n);
draw arduino.D2 -- wire14[1] -- wire14[2] -- wire14[3];

endfig;

end
