outputtemplate:="%j.eps"; prologues:=3;
input makecirc; initlatex("");

beginfig(1);
pair out[];
ground.a(origin,simple,0);
impedance1(gnd.a+up*2*imp+up*.3cm,-90,"Z1","1K");
J1=Z1l+up*1cm;
junction1("J1")(lft);
wire(gnd.a,Z1r,nsq);
T1C=J1+up*1cm;
T1E=T1C+(0,3bjt)rotated0;
T1B=T1C+(0,2.5bjt)rotated(0+angle(1.5,2));
transistor1(cpnp,"T1");

wire(Z1l,J1,nsq);
wire(J1,T1C,nsq);
out2=J1+right*2cm;
wire(J1,out2,nsq); label.rt(btex new Out 1 etex, out2);

endfig;

end
