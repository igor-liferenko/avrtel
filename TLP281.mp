outputtemplate:="%j.eps"; prologues:=3;
input circuit;

% when you will get rid of makecirc, move mpcirctmp.mp from .gitigrone, TODO.makecirc, README.makecirc, makecirc.mp and latex.mp to ~/makecirc/new/

beginfig(1);
imp:=1/2*1.5*7mm; % half of element (element = resistor size + half resistor size for connectors)
bjt:=1/2*7mm; % half of element (element = width of transistor)
z0l=origin;
z0r=(0,-5mm);
ground0(simple,3mm);
z3l=origin;
z3r=z3l+(2imp,0)rotated 90;
impedance3;
label.lft(btex 1K etex, 1/2[z3l,z3r]+(0,.1cm)rotated(angle(z3r-z3l)));
z2=z3r+up*1cm;
draw z3r--z2 withpen line;
drawdot z2 withpen pencircle scaled 4pt;
z1c=z2+up*1cm;
z1e=z1c+(0,3bjt)rotated0;
z1b=z1c+(0,2.5bjt)rotated(0+angle(1.5,2));
transistor1(cpnp);
draw z2--z1c withpen line;
label.bot(btex HGND etex, z0r);
z4=z2+right*1cm;
draw z2--z4 withpen line;
label.rt(btex new Out 1 etex, z4);
z5=z1e+up*1cm;
draw z1e--z5 withpen line;
label.top(btex HVCC etex, z5);
z6=z1b+left*1cm;
draw z1b--z6 withpen line;
label.lft(btex Out 1 etex, z6);

endfig;

end
