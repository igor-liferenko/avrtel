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
draw fullcircle scaled 30pt;
endfig;

end
