%Tiene como entrada la temperatura, la irradiacion y voltaje
%Entrega la corriente del panel bajo esas condiciones

function I_pv = PV(T,G,V)

%Parametros
n=1.52;
k=1.38e-23;
q=1.60e-19;
vg=1.12;
ns = 60;
tstc = 298;
vocn = 36.1;
isc = 8.13;

voc=vocn/ns;
dvdi = -0.44 / ns; 
io = isc/(exp((q*voc)/(n*k*tstc))-1);
xv = io*(q/(n*k*tstc))*exp((q*voc)/(n*k*tstc));
rs = -dvdi - 1/xv;

if V <= 0
    I=0;
end

j=0;
tmodel = T + 273;

il = G*isc/1000;
ilt = il * (1 + 0.00053*(tmodel - tstc));
iot = io*((tmodel/tstc)^(3/n))*exp(((-q*vg)/(n*k))*(1/tmodel - 1/tstc));

vc = V/ns;
I = 5;

if V <= 0
    I=0;
else 
    for j=0:1:26
        ia = I - ((ilt - I - (iot*(exp((q*(vc+I*rs))/(n*k*tmodel))-1))) / (-1 - (iot*(exp((q*(vc+I*rs))/(n*k*tmodel))-1)*((rs*q)/(n*k*tmodel)))));
        I = ia;
        if I <= 0
            I = 0;
        end
    end
end
    I_pv = I;
end