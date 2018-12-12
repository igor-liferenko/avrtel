% Macros for the pens, I define them as such so when they expand,
% look for the last value assigned to linewd and use it
% (thanks to JLD). The linewd value assigns it as newinternal to
% be able to change it «from out».

newinternal linewd;
linewd:=0.25mm;

def line = pencircle scaled linewd enddef;
def misc = pencircle scaled .8linewd enddef;

%%%%% arrow

vardef bjtahead expr p =
save A,u,a,b; pair A,u; path a,b;
A := point 0.7length(p) of p;
u := unitvector(direction length(p)/2 of p);
a := A--(A - ahlength*u rotated 20);
b := A--(A - ahlength*u rotated -20);
(a & reverse(a) & b & reverse(b))--cycle
enddef;

%%%<--- Transistor --->%%%
newinternal npn, pnp, cnpn, cpnp;
npn:=1; pnp:=-1; cnpn:=0; cpnp:=2;

vardef transistor@#(expr type)=
  save BJT;
  picture BJT;
  BJT:=nullpicture;

  addto BJT doublepath z@#.b--1/2[1/2[z@#.c,z@#.e],z@#.b] withpen line;
  addto BJT doublepath 1/2[1/2[z@#.c,z@#.e],z@#.b]+(1/3abs(z@#.e-z@#.c),0)
    rotated(angle(z@#.e-z@#.c))--1/2[1/2[z@#.c,z@#.e],z@#.b]+
    (1/3abs(z@#.c-z@#.e),0)rotated(angle(z@#.c-z@#.e)) withpen line;
  addto BJT doublepath 1/2[1/2[z@#.c,z@#.e],z@#.b]+(2/15abs(z@#.c-z@#.e),0)
    rotated(angle(z@#.c-z@#.e))--1/6[z@#.c,z@#.e]--z@#.c withpen line;

	if type=npn:
		addto BJT doublepath (z+(.5bjtlth,-.2bjtlth))--(z+(bjtlth,-.5bjtlth))
		--(z+(bjtlth,-.75bjtlth)) withpen line;
		addto BJT contour bjtahead (z+(.5bjtlth,-.2bjtlth))
		--(z+(bjtlth,-.5bjtlth)) withpen line;
	elseif type=cnpn:
		addto BJT doublepath (z+(.5bjtlth,-.2bjtlth))--(z+(bjtlth,-.5bjtlth))
		--(z+(bjtlth,-.75bjtlth)) withpen line;
		addto BJT contour bjtahead (z+(.5bjtlth,-.2bjtlth))
		--(z+(bjtlth,-.5bjtlth)) withpen line;
		addto BJT doublepath fullcircle scaled 1.3bjtlth shifted (z+(.65bjtlth,0))
		 withpen line;
  elseif type=pnp:
                addto BJT doublepath (z+(bjtlth,-.75bjtlth))--(z+(bjtlth,-.5bjtlth))
                --(z+(.5bjtlth,-.2bjtlth)) withpen line;
                addto BJT contour bjtahead (z+(bjtlth,-.5bjtlth))
                --(z+(.5bjtlth,-.2bjtlth)) withpen line;
  elseif type=cpnp:
    addto BJT doublepath z@#.e--1/6[z@#.e,z@#.c]--1/2[1/2[z@#.c,z@#.e],z@#.b]+
      (2/15abs(z@#.e-z@#.c),0)rotated(angle(z@#.e-z@#.c)) withpen line;
    addto BJT contour bjtahead 1/6[z@#.e,z@#.c]--1/2[1/2[z@#.c,z@#.e],z@#.b]+
      (2/15abs(z@#.e-z@#.c),0)rotated(angle(z@#.e-z@#.c)) withpen line;
    addto BJT doublepath fullcircle scaled 1.3abs(z@#.b-1/2[z@#.c,z@#.e]) shifted .65[z@#.b,1/2[z@#.c,z@#.e]]
      withpen line;
  fi;

  draw BJT;
enddef;

vardef impedance@#=
  draw z@#.l--1/6[z@#.l,z@#.r];
  draw 1/6[z@#.l,z@#.r]+(0,3/25abs(z@#.r-z@#.l))rotated(angle(z@#.r-z@#.l))--
         1/6[z@#.l,z@#.r]+(0,3/25abs(z@#.l-z@#.r))rotated(angle(z@#.l-z@#.r))--
         5/6[z@#.l,z@#.r]+(0,3/25abs(z@#.l-z@#.r))rotated(angle(z@#.l-z@#.r))--
         5/6[z@#.l,z@#.r]+(0,3/25abs(z@#.r-z@#.l))rotated(angle(z@#.r-z@#.l))--cycle;
  draw 5/6[z@#.l,z@#.r]--z@#.r;
enddef;

newinternal simple, shield;
simple:=1; shield:=2;

vardef ground@#(expr type)=
  save GND;
  picture GND; GND:=nullpicture;
  addto GND doublepath z@#.o--7/10[z@#.o,z@#.b] withpen line;
  if type=shield:
    addto GND doublepath 7/10[z@#.o,z@#.b]+(0,1/2abs(z@#.o-z@#.b))rotated(angle(z@#.b-z@#.o))--7/10[z@#.o,z@#.b]+(0,-1/2abs(z@#.o-z@#.b))rotated(angle(z@#.b-z@#.o)) withpen line;
    addto GND doublepath 85/100[z@#.o,z@#.b]+(0,3/10abs(z@#.o-z@#.b))rotated(angle(z@#.b-z@#.o))--85/100[z@#.o,z@#.b]+(0,-3/10abs(z@#.o-z@#.b))rotated(angle(z@#.b-z@#.o)) withpen line;
    addto GND doublepath z@#.b+(0,1/10abs(z@#.o-z@#.b))rotated(angle(z@#.b-z@#.o))--z@#.b+(0,-1/10abs(z@#.o-z@#.b))rotated(angle(z@#.b-z@#.o)) withpen line;
  elseif type=simple:
    addto GND doublepath z@#.b+(0,1/2abs(z@#.o-z@#.b))rotated(angle(z@#.b-z@#.o))--z@#.b+(0,-1/2abs(z@#.o-z@#.b))rotated(angle(z@#.b-z@#.o)) withpen pencircle scaled 2linewd;
  fi;
  draw GND;
enddef;

newinternal normal, electrolytic, variable, variant, platsep;
normal:=0; electrolytic:=1; variable:=2; platsep:=1mm; variant:=3;
vardef capacitor@#(expr type)=
  draw z@#.l--9/20[z@#.l,z@#.r];
  draw 9/20[z@#.l,z@#.r]+(0,3/25abs(z@#.r-z@#.l))rotated(angle(z@#.r-z@#.l))--
    9/20[z@#.l,z@#.r]+(0,3/25abs(z@#.l-z@#.r))rotated(angle(z@#.l-z@#.r)) withpen pencircle scaled 2linewd;
  draw 11/20[z@#.l,z@#.r]+(0,3/25abs(z@#.l-z@#.r))rotated(angle(z@#.l-z@#.r))--
    11/20[z@#.l,z@#.r]+(0,3/25abs(z@#.r-z@#.l))rotated(angle(z@#.r-z@#.l)) withpen pencircle scaled 2linewd;
  draw 11/20[z@#.l,z@#.r]--z@#.r;
enddef;
