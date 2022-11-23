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

T_daily_module_RANDOM = transpose(T_daily_module(1,:));
G_daily_RANDOM = transpose(G_daily(1,:));

% Calculo curva de potencia de 1 panel

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

P_maxima = max(P_max);
N_pv = P_electrolizador/P_maxima;

%% Calculo tamaño bateria Ah

t = (0:1:minutes_per_day)';
unitstep = t>=0;


figure(5)
hold on
plot(50000*unitstep/1000,'','color','#228C22')
plot(P_max*N_pv/1000)
ylabel('Potencia [kW]')
xlabel('Tiempo[min]')
ylim([0 51])
xlim([0 1441])
%legend('Potencia total producida')
hold off

%{
figure(6)
hold on
plot(E_pv*N_pv)
ylabel('Energia [J]')
xlabel('Tiempo [min]')
legend('Energia total producida')
hold off
%}
