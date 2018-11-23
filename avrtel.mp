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
label(btex \font\x=cmr10 scaled\magstep2 \x DEVICE etex, z0);
draw unitsquare shifted (-.5,-.5) xscaled 5.1u yscaled 1.1u shifted z0;
label(btex \font\x=cmbx10 scaled\magstep2 \x ep0 etex, z1);
draw fullcircle scaled 1.7u shifted z1;
label(btex \font\x=cmbx10 scaled\magstep2 \x cfg1 etex, z2);
draw fullcircle scaled 1.7u shifted z2;
label(btex \font\x=cmbx10 scaled\magstep2 \x if1 etex, z3);
draw fullcircle scaled 1.7u shifted z3;
label(btex \font\x=cmbx10 scaled\magstep2 \x if1 etex, z4);
draw fullcircle scaled 1.7u shifted z4;
label(btex \font\x=cmbx10 scaled\magstep2 \x alt0 etex, z5);
draw fullcircle scaled 1.7u shifted z5;
label(btex \font\x=cmbx10 scaled\magstep2 \x alt0 etex, z6);
draw fullcircle scaled 1.7u shifted z6;
label(btex \font\x=cmbx10 scaled\magstep2 \x ep1 etex, z7);
draw fullcircle scaled 1.7u shifted z7;
label(btex \font\x=cmbx10 scaled\magstep2 \x ep2 etex, z8);
draw fullcircle scaled 1.7u shifted z8;
label(btex \font\x=cmbx10 scaled\magstep2 \x ep3 etex, z9);
draw fullcircle scaled 1.7u shifted z9;
draw (x1,y0-.55u) -- (x1,y1+r);
draw (x2,y0-.55u) -- (x2,y2+r);
draw (x2,y2-r) -- (x3,y3+r);
draw (x2+r*(x4-x2)/length(z4-z2),y2+r*(y4-y2)/length(z4-z2)) -- (x4+r*(x2-x4)/length(z2-z4),y4+r*(y2-y4)/length(z2-z4));
draw (x3,y3-r) -- (x5,y5+r);
draw (x4,y4-r) -- (x6,y6+r);
draw (x5+r*(x7-x5)/length(z7-z5),y5+r*(y7-y5)/length(z7-z5)) -- (x7+r*(x5-x7)/length(z5-z7),y7+r*(y5-y7)/length(z5-z7));
draw (x5+r*(x8-x5)/length(z8-z5),y5+r*(y8-y5)/length(z8-z5)) -- (x8+r*(x5-x8)/length(z5-z8),y8+r*(y5-y8)/length(z5-z8));
draw (x6,y6-r) -- (x9,y9+r);
endfig;
beginfig(2)
endfig;
%etc
end
