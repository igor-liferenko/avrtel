beginfig(1)
u=1cm;
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
draw (x1,y0-.55u) -- (x1,y1+.85u);
draw (x2,y0-.55u) -- (x2,y2+.85u);
draw (x2,y2-.85u) -- (x3,y3+.85u);
draw z2 -- z4;
draw (x3,y3-.85u) -- (x5,y5+.85u);
draw (x4,y4-.85u) -- (x6,y6+.85u);
draw z5 -- z7;
draw z5 -- z8;
draw (x6,y6-.85u) -- (x9,y9+.85u);
endfig;
beginfig(2)
endfig;
%etc
end
