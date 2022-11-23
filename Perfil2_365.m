clear all
close all
clc
load('Antofagasta_data_daily.mat')

days=365;
minutes_per_day=1440;
G_stc=1000;
T_noct=25; % a dejar asi

datestr(Date_daily(1)); % eso para ver la fecha que corresponde al día 1
datestr(Date_daily(end)); % y eso da la fecha del ultimo día

%% Temperature correction.
contador = 0;
for k=1:days
    for l=1:minutes_per_day
        T_daily_module(k,l)=T_daily(k,l)+G_daily(k,l)/G_stc*(T_noct-20); % Module temperature correction
    end
end

%{
figure(1)
subplot(2,1,1)
plot(minutes,T_daily_module(2,:))
ylabel('Temperature (°C)')
subplot(2,1,2)
plot(minutes,G_daily(2,:))
ylabel('Irradiation (W/m2)')
hold on
%}

Bateria365 = [];
N_pv365 = [];
Potencia365 = [];

for j=1:1:days


if j == 235
    N_pv365 = [N_pv365;0];
    Bateria365 = [Bateria365;0];
elseif j ==236 
    N_pv365 = [N_pv365;0];
    Bateria365 = [Bateria365;0];
elseif j == 237
    N_pv365 = [N_pv365;0];
    Bateria365 = [Bateria365;0];
elseif j == 238
    N_pv365 = [N_pv365;0];
    Bateria365 = [Bateria365;0];
elseif j == 239
    N_pv365 = [N_pv365;0];
    Bateria365 = [Bateria365;0];
elseif j == 240
    N_pv365 = [N_pv365;0];
    Bateria365 = [Bateria365;0];
elseif j == 241
    N_pv365 = [N_pv365;0];
    Bateria365 = [Bateria365;0];
elseif j == 246
    N_pv365 = [N_pv365;0];
    Bateria365 = [Bateria365;0];    
else

T_daily_module_RANDOM = transpose(T_daily_module(j,:));
G_daily_RANDOM = transpose(G_daily(j,:));


% Calculo curva de potencia

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

% Calculo Numero de paneles

Energia_panel = (60*60*24*max(Energia_panel))/minutes_per_day;
E_planta = P_electrolizador*24*3600;
N_pv = E_planta/Energia_panel;


% Calculo tamaño bateria Ah

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

% E_bateria es el vector que contiene la energia acumulada por el panel
% durante 1440 minutos, entonces hay que multiplicar la energia obtenida
% (En minutos) por 60 y asi obtenerla en Joule segundo. No multiplico por 
% 24, por que eso ya esta considerando en los 1440 puntos de muestreo.

Bateria_J = max(E_bateria*60);               %[J en segundos]
Bateria_Wh = (Bateria_J/3600);               %[Wh]
Bateria_Ah = Bateria_Wh/400;                 %[Ah con bat de 400V]
 
N_pv365 = [N_pv365;N_pv];
Bateria365 = [Bateria365;Bateria_Wh];
contador = contador + 1
end
Potencia365 = [Potencia365 P_max];
end

