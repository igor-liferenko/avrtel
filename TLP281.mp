outputtemplate:="%j.eps"; prologues:=3;
input makecirc; initlatex("");

% do not use names of elements
% when you will get rid of makecirc, move mpcirctmp.mp from .gitigrone, TODO.makecirc, README.makecirc, makecirc.mp and latex.mp to ~/makecirc/new/

beginfig(1);
ground.a(origin,simple,0);
z3l=origin;
z3r=z3l+(2imp,0)rotated 90;
impedance3;
label.rt(btex 1K etex, 1/2[z3l,z3r]+(.5cm,0)rotated(angle(z3r-z3l)));
z2=z3r+up*1cm;
drawdot z2 withpen pencircle scaled 2pt;
z1c=z2+up*1cm;
z1e=z1c+(0,3bjt)rotated0;
z1b=z1c+(0,2.5bjt)rotated(0+angle(1.5,2));
transistor1(cpnp);

endfig;

end
