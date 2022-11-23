clear all
close all
clc

load("Perfil1_B365.mat")
load("Perfil1_N365.mat")
load("Perfil1_P365.mat")

B365 = [];
for i=1:1:365
    if (i ~= 235) && (i ~= 236) && (i ~= 237) && (i ~= 238) && (i ~= 239) && (i ~= 240) && (i ~= 241) && (i ~= 246)  
        B365 = [B365;Bateria365(i)];
    end
end

N365 = [];
for i=1:1:365
    if (i ~= 235) && (i ~= 236) && (i ~= 237) && (i ~= 238) && (i ~= 239) && (i ~= 240) && (i ~= 241) && (i ~= 246)  
        N365 = [N365;N_pv365(i)];
    end
end

t = (0:1:365)';
unitstep = t>=0;

[desv_Npv,me_Npv] = std(N365);
[desv_Bat,me_Bat] = std(B365);

% Obtenidos de distributionFitter archivo gammaNpv1
Npv_prom = 249;

Sdim_Npv = (1+6/100);

Npv = Npv_prom*Sdim_Npv
Bat = 0;

%{
figure(1)
hold on
plot(B365)
ylabel('Capacidad bateria [MWh]')
xlabel('Tiempo [días]')
xlim([0 365])
%plot(Bat*unitstep)
%plot(me_Bat*unitstep)
hold off


figure(2)
hold on
plot(N365)
ylabel('Numero paneles solares')
xlabel('Tiempo [días]')
xlim([0 365])
plot(Npv*unitstep)
%plot(me_Npv*unitstep)
hold off
%}
%% Perfil 1

P_PV = 280;                             % Potencia nominal de un panel

% Sistema PV sin bateria, sistema PV que esta dimensionado a 50kW.

%Potencia nominal instalada PV [W]
P_PV_h1 = Npv*P_PV;            % Potencia nom instalada [W]

suma = 0;
Pot_prom_dia = [];
for i=1:1:365
    suma = sum(Potencia365(:,i))/24;   % Potencia promedio dia [Wh]
    Pot_prom_dia = [Pot_prom_dia;suma];
end

Pot_prom = 0;
suma = 0;
for i=1:1:365
    suma = suma + Pot_prom_dia(i);
end

P_E = 50000;

H2V = suma/365/4830;                         % Conversion kWh a Nm3/h.
masa_H = 2;                                 % Masa hidrogeno [gr]
H2V_kg_h1 = H2V*0.044*masa_H;            % Conversion Nm3/h a kg/h                  
H2V1 = H2V_kg_h1*24*365

% Calculo LCOH
LCOH1 = LCOH(P_PV_h1/1000,0,P_E/1000,H2V1)    %[$-ct por kW]
LCOH1 = LCOH1/3                                %[€ por kgh2v]
%}