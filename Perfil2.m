clear all
close all
clc
load('Antofagasta_data_daily.mat')

days=365;
minutes_per_day=1440;
G_stc=1000;
T_noct=25; % a dejar asi
%T_noct = 43.8        %Normal operating cell temperature

datestr(Date_daily(1)); % eso para ver la fecha que corresponde al día 1
datestr(Date_daily(end)); % y eso da la fecha del ultimo día

%% Temperature correction.
for k=1:days
    for l=1:minutes_per_day
        T_daily_module(k,l)=T_daily(k,l)+G_daily(k,l)/G_stc*(T_noct-20); % Module temperature correction
    end
end


figure(1)
subplot(2,1,1)
plot(minutes,T_daily_module(2,:))
ylabel('Temperature (°C)')
subplot(2,1,2)
plot(minutes,G_daily(2,:))
ylabel('Irradiation (W/m2)')
hold on
%}

T_daily_module_RANDOM = transpose(T_daily_module(1,:));
G_daily_RANDOM = transpose(G_daily(1,:));

%% Calculo curva de potencia

P_electrolizador = 50000;
tiempo = 1:1:minutes_per_day;
P_max = [];

for i=1:1:minutes_per_day
    P_max = [P_max;P_PV(T_daily_module_RANDOM(i),G_daily_RANDOM(i))];
end

E_pv = [];                                   %Energia de un panel
Energia_panel = 0;
for i=1:1:minutes_per_day
    Energia_panel = Energia_panel + P_max(i);
    E_pv = [E_pv;Energia_panel];
end

%% Calculo Numero de paneles

Energia_panel = (60*60*24*max(Energia_panel))/minutes_per_day;
E_planta = P_electrolizador*24*3600;
N_pv = E_planta/Energia_panel

%% Calculo tamaño bateria Ah

P_utilizada = []; %Potencia producida por el panel, y utilizada por el electrolizador
for i=1:1:minutes_per_day
    if N_pv*P_max(i)<P_electrolizador
        P_utilizada = [P_utilizada;N_pv*P_max(i)];
    else
        P_utilizada = [P_utilizada;P_electrolizador];
    end
end

P_faltante =[];
for i=1:1:minutes_per_day
    if N_pv*P_max(i)<P_electrolizador
        P_faltante = [P_faltante;P_electrolizador-N_pv*P_max(i)];
    else
        P_faltante = [P_faltante;0];
    end
end

E_utilizada = [];
E_pv_utilizada = 0;
for i=1:1:minutes_per_day
    E_pv_utilizada = E_pv_utilizada + P_utilizada(i);
    E_utilizada = [E_utilizada;E_pv_utilizada];
end

E_bateria = [];
E_pv_bateria = 0;
for i=1:1:minutes_per_day
    E_pv_bateria = E_pv_bateria + P_faltante(i);
    E_bateria = [E_bateria;E_pv_bateria];
end

step = [];
for i = 1:1:minutes_per_day
    if i < 478
        step = [step;0];
    elseif i < 1041
        step = [step;50000/1000];
    else
        step = [step;0];
    end
end
    
t = (477:1:1040)';
unitstep = t>=0;


figure(5)
hold on
%plot(P_utilizada/1000)
plot(P_max*N_pv/1000)
%plot(step)
plot(P_faltante/1000)
ylabel('Potencia [kW]')
xlabel('Tiempo[min]')
xlim([0 1440])
%legend('Potencia producida y utilizada','Potencia total producida','Potencia faltante')
hold off

% E_bateria es el vector que contiene la energia acumulada por el panel
% durante 1440 minutos, entonces hay que multiplicar la energia obtenida
% (En minutos) por 60 y asi obtenerla en Joule segundo. No multiplico por 
% 24, por que eso ya esta considerando en los 1440 puntos de muestreo.

Bateria_J = max(E_bateria*60);                %[J en segundos]
Bateria_Wh = (Bateria_J/3600)                %[Wh]
Bateria_Ah = Bateria_Wh/400;                  %[Ah con bat de 400V]

P_PV = 280;                             % Potencia nominal de un panel

P_BAT2 = Bateria_Wh

P_E = 50000

H2V_h2 = 50000/4830;                        
H2V_kg_h2 = H2V_h2*0.0898;                  
H2V2 = H2V_kg_h2*24*365

LCOH2 = LCOH(N_pv*P_PV/1000,P_BAT2/1000,P_E/1000,H2V2)/3

