clear all
close all
clc

load("Perfil2_B365.mat")
load("Perfil2_N365.mat")
load("Perfil2_P365.mat")

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
Npv_gamma_90 = 1003;
Bat_gamma_90 = 729837;

Sdim_Npv = (1+6/100);
Sdim_Bat = (1+6/100);

Npv = Npv_gamma_90*Sdim_Npv                 %[pu]
Bat = Bat_gamma_90*Sdim_Bat                 %[Wh]

%{
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

%% Perfil 2
P_PV = 280;                                 % Potencia nominal de un panel

% Sistema PV con bateria, el cual suministra 50kW de potencia electrica a 
% un electrolizador de manera interrupida.

%Potencia nominal instalada PV [W]
P_PV_h2 = Npv*P_PV;            

%Potencia nominal instalada bateria [Wh]
P_BAT2 = Bat;

% Potencia electrica a kg de H2V [W]
P_E = 50000;

H2V_h2 = 50000/4830;                        % Conversion Wh a Nm3/h.
masa_H = 2;                                 % Masa hidrogeno [gr]
H2V_kg_h2 = H2V_h2*0.044*masa_H;            % Conversion Nm3/h a kg/h                  
H2V2 = H2V_kg_h2*24*365                     % [kg al año]

% Calculo LCOH
LCOH2 = LCOH(P_PV_h2/1000,P_BAT2/1000,P_E/1000,H2V2)   %[$-ct por kW]
LCOH2 = LCOH2/3                                         %[€ por kgh2v]
%}