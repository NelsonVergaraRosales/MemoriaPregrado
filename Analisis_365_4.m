clear all
close all
clc

load("Perfil4_B365.mat")
load("Perfil4_N365.mat")
load("Perfil4_P365.mat")

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
Npv_gamma_90 = 531;
Bat_gamma_90 = 209214;

Sdim_Npv = (1+6/100);
Sdim_Bat = (1+6/100);

Npv = Npv_gamma_90*Sdim_Npv;                %[pu]
Bat = Bat_gamma_90*Sdim_Bat;                 %[Wh]

Perdidas_apagado = 0.1;

Npv = Npv*(1+Perdidas_apagado)
Bat = Bat*(1+Perdidas_apagado)


figure(1)
hold on
plot(B365/1000/1000)
ylabel('Capacidad bateria [MWh]')
xlabel('Tiempo [días]')
xlim([0 365])
plot(Bat*unitstep/1000/1000)
%plot(me_Bat*unitstep/1000/1000)
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
%% Perfil 4

P_PV = 280;                             % Potencia nominal de un panel

% Sistema PV con bateriam el cual suministra 50kW de potencia electrica a
% un electrolizador en las horas luz, y deja de operar en las horas de no
% luz

%Potencia nominal instalada PV [W]
P_PV_h4 = Npv*P_PV;            % Potencia nom instalada [W]

%Potencia nominal instalada bateria [W]
P_BAT4 = Bat;

P_E = 50000;

% Potencia electrica a kg de H2V
H2V_h4 = 50000/4830*((762/1440)+0.0*(678/1440));    % Conversion kWh a Nm3/h
masa_H = 2;                                         % Masa hisrogeno [gr]
H2V_kg_h4 = H2V_h4*0.044*masa_H;                    % Conversion Nm3/h a kg/h
H2V4 = H2V_kg_h4*24*365                            % Se considera 

% Calculo LCOH
LCOH4 = LCOH(P_PV_h4/1000,P_BAT4/1000,P_E/1000,H2V4) %[$-ct por kW]
LCOH4 = LCOH4/3                                      %[€ por kgh2v]