% Tiene como entrada la temperatura y la irradiancia. 
% Entrega la potencia maxima que se puede extraer bajo esas condiciones
function Vector_P = P_PV(T,G)

P = [];

for i=0:1:70
    corriente = PV(T,G,i);
    potencia = corriente*i;
    P = [P;potencia];
end

Vector_P = max(P);



