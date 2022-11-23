clear all
close all
clc

load("Perfil6_B365.mat")
load("Perfil6_N365.mat")
load("Perfil6_P365.mat")
P_PV = 280;                             % Potencia nominal de un panel

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

% Obtenidos de distributionFitter archivo gammaNpv2 y gammaBat2
Npv_gamma_90 = 346;
Bat_gamma_90 = 0;

Sdim_Npv = (1+6/100);
Sdim_Bat = (1+6/100);

Npv = Npv_gamma_90*Sdim_Npv                 %[pu]
Bat = Bat_gamma_90*Sdim_Bat                 %[Wh]

figure(1)
hold on
plot(B365/1000/1000)
ylabel('Capacidad bateria [MWh]')
xlabel('Tiempo [días]')
xlim([0 365])
plot(Bat*unitstep/1000/1000)
plot(me_Bat*unitstep/1000/1000)
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

%% Perfil 6

% Sistema PV sobredimensionado a 75kW, sin bateria.

%Potencia nominal instalada PV [W]
P_PV_h6 = Npv*P_PV;            % Potencia nom instalada [W]

suma6 = 0;
Pot_prom_dia6 = [];
for i=1:1:358
    suma6 = sum(Potencia365(:,i))/24;   % Potencia promedio dia [Wh]
    Pot_prom_dia6 = [Pot_prom_dia6;suma6];
end

Pot_prom6 = 0;
suma6 = 0;
for i=1:1:358
    suma6 = suma6 + Pot_prom_dia6(i);
end

P_E = 50000;

H2V_h6 = suma6/365/4830;                         % Conversion kWh a Nm3/h
masa_H = 2;                                         % Masa hisrogeno [gr]
H2V_kg_h6 = H2V_h6*0.044*masa_H;                    % Conversion Nm3/h a kg/h
H2V6 = H2V_kg_h6*24*365

% Calculo LCOH
LCOH6 = LCOH(P_PV_h6/1000,0,P_E/1000,H2V6)          %[$-ct por kW]
LCOH6 = LCOH6/3                                     %[€ por kgh2v]