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

T_daily_module_RANDOM = transpose(T_daily_module(1,:));
G_daily_RANDOM = transpose(G_daily(1,:));

% Calculo curva de potencia de un panel

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

P_noche = 0.0; % Potencia producida en la noche, en veces
Energia_panel = (60*60*(minutes_per_day/60)*max(Energia_panel))/minutes_per_day;
E_planta = P_electrolizador*(762/60)*3600 + P_electrolizador*(678/60)*3600*P_noche;
N_pv = E_planta/Energia_panel;

% Calculo tamaño bateria Ah

P_utilizada = []; %Potencia producida por los paneles, y utilizada por el electrolizador
for i=1:1:minutes_per_day
    if N_pv*P_max(i)<P_electrolizador
        P_utilizada = [P_utilizada;N_pv*P_max(i)];
    else
        P_utilizada = [P_utilizada;P_electrolizador];
    end
end

P_faltante =[];
for i=1:1:minutes_per_day
    if i < 379
        if N_pv*P_max(i)<P_electrolizador*P_noche
            P_faltante = [P_faltante;P_electrolizador*P_noche-N_pv*P_max(i)];
        else 
            P_faltante = [P_faltante;0];
        end
    elseif i < 1141
        if N_pv*P_max(i)<P_electrolizador
            P_faltante = [P_faltante;P_electrolizador-N_pv*P_max(i)];
        else
            P_faltante = [P_faltante;0];
        end
    else
        if N_pv*P_max(i)<P_electrolizador*P_noche
            P_faltante = [P_faltante;P_electrolizador*P_noche-N_pv*P_max(i)];
        else 
            P_faltante = [P_faltante;0];
        end  
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


figure(5)
hold on
%plot(P_utilizada)
plot(P_max*N_pv/1000)
plot(P_faltante/1000)
ylabel('Potencia [kW]')
xlabel('Tiempo[min]')
xlim([0 1441])
%legend('Potencia producida y utilizada','Potencia total producida','Potencia faltante')
hold off


%{
figure(6)
hold on
plot((E_pv*N_pv)-(E_utilizada))
plot(E_pv*N_pv)
plot(E_bateria)
ylabel('Energia [J]')
xlabel('Tiempo [min]')
legend('Energia sobrante','Energia total producida','Energia Faltante')
hold off
%}

% E_bateria es el vector que contiene la energia acumulada por el panel
% durante 1440 minutos, entonces hay que multiplicar la energia obtenida
% (En minutos) por 60 y asi obtenerla en Joule segundo. No multiplico por 
% 24, por que eso ya esta considerando en los 1440 puntos de muestreo.

Bateria_J = max(E_bateria*60);               %[J en segundos]
Bateria_Wh = (Bateria_J/3600);               %[Wh]
Bateria_Ah = Bateria_Wh/400;                 %[Ah con bat de 400V]

