clear all
close all
clc

load("Perfil3_B365.mat")
load("Perfil3_N365.mat")
load("Perfil3_P365.mat")

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
Npv_prom = 579;
Bat_prom = 257856;

Sdim_Npv = (1+6/100);
Sdim_Bat = (1+6/100);

Npv = Npv_prom*Sdim_Npv
Bat = Bat_prom*Sdim_Bat

figure(1)
hold on
plot(B365)
ylabel('Capacidad bateria [MWh]')
xlabel('Tiempo [días]')
xlim([0 365])
plot(Bat*unitstep)
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


%% Perfil 3

P_PV = 280;                             % Potencia nominal de un panel

% Sistema PV con bateria, el cual suministra 50kW de potencia electrica a 
% un electrolizador en las horas luz, y opera a un 10% de la potencia 
% nominal del electrolizador en horas de no luz

%Potencia nominal instalada PV [W]
P_PV_h3 = Npv*P_PV;            % Potencia nom instalada [W]

%Potencia nominal instalada bateria [Wh]
P_BAT3 = Bat;

P_E = 50000;

% Potencia electrica a kg de H2V
H2V_h3 = 50000/4830*((762/1440)+0.1*(678/1440));    % Conversion kWh a Nm3/h
masa_H = 2;                                 % Masa hidrogeno [gr]
H2V_kg_h3 = H2V_h3*0.044*masa_H;            % Conversion Nm3/h a kg/h                  
H2V3 = H2V_kg_h3*24*365                            % Se considera 

% Calculo LCOH
LCOH3 = LCOH(P_PV_h3/1000,P_BAT3/1000,P_E/1000,H2V3) %[$-ct por kW]
LCOH3 = LCOH3/3                                      %[€ por kgh2v]
