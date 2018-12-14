%outputtemplate:="%j.eps"; prologues:=3;
input circuit;

beginfig(1);
imp:=1/2*1.5*7mm; % half of element (element = resistor size + half resistor size for connectors)
bjt:=1/2*7mm; % half of element (element = width of transistor)
gnd:=5mm; % side of square in which the picture is contained

z0o=origin;
z0b=(0,-gnd);
z3l=z0o;
z3r=z3l+(2imp,0)rotated 90;
z2=z3r+up*5mm;
z1c=z2+up*5mm;
z1e=z1c+(0,3bjt)rotated0;
z1b=z1c+(0,2.5bjt)rotated(0+angle(1.5,2));
z4=z2+right*1cm;
z5=z1e+up*8mm;
z6=z1b+left*1cm;

ground0(simple); label.bot(btex HGND etex, z0b+down*1mm);
impedance3; label.lft(btex 1K etex, 1/2[z3l,z3r]+(0,1mm)rotated(angle(z3r-z3l)));
draw z3r--z2;
drawdot z2 withpen pencircle scaled 4pt;
draw z2--z4; label.rt(btex new Out 1 etex, z4);
draw z2--z1c;
transistor1(cpnp);
draw z1b--z6; label.lft(btex Out 1 etex, z6);
draw z1e--z5; label.top(btex HVCC etex, z5);

endfig;

end
