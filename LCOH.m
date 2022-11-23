function LCOH = LCOH(INP_PV,INP_BAT,INP_E,AHP)
%funcion basada en paper Grube2020

%% DEPRECIATION PERIOD (DP)(en años)

DP_PV = 25;                                 %DP PV  
DP_PEM = 10;                                %DP Electroliador
DP_PE = 25;                                 %DP Electronica de potencia
DP_BAT = 15;                                %DP Bateria

%% SPECIFIC INVESTMENT COST (SIC)(EURO por kW)
% Datos tomados de Alvaro2019 y Grube2020

SIC_PV = 800;                               %SIC PV
% Para PV, se considera el el 47% del precio corresponde a los modulos PV, y
% el 53% restante al inversor. 
% Informes del 2016 indican que los modulos en EEUU cuesta 1,25 Euro/W y 
% 2,2 Euro/W en Alemania
% Para los inversores, 100 Euro/kW se estima para el año 2025
SIC_PEM = 600;                              %SIC Electrolizador
% Considerar que se deben instalar 3 electrolizadores durante el proyecto
% de 25 años, debido a su depreciacion de 10 años.
SIC_PE = 85;                                %SIC Electronica de potencia

%De aca saco supuesto que bateria requiere de 500 Euros/kW
%https://pdf.sciencedirectassets.com/277910/1-s2.0-S1876610215X00129/1-s2.0-S1876610215013235/main.pdf?X-Amz-Security-Token=IQoJb3JpZ2luX2VjEOP%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJHMEUCIHjafXt1Z%2BY4QJ34Ou4qZG05G0Ey6LTgKLJ3IJVL4QHQAiEAqMUrb1CWPAbLBswQunOGViinhm%2B97wKR7Jv8gHW6CpAq1QQIjP%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARAFGgwwNTkwMDM1NDY4NjUiDDCrS56eG26or60LeyqpBBqv7rTyBRIrm5Rk3YbbgHZXu6IENRpCgX%2BRYfRPEzbK32%2FhqnWdjMTnqLjZyUZhzpNyeug3CFd16alJXBb9zW4QekSlGmiVYkUK3XklkGLA923rqLEuiohU9RRX350iCEushfs3%2BwStdKYSftcrnqASX3AmsMtpc5%2FdLQRxr7BPxxJha57wPuEM4JvmKaG316DxmEis%2FjIgZLHF%2BiOuyEDZuz5QpWEpg%2BFSkIeR1Xq1vlyAlFoQcNsapERK0MF2V3oMl2VvahT7%2BKyAhJGF8rlelIMVA1xvmmLDwIFJjZVQiSrPrMtcEO%2BtStnUYXQHBve0ahB3bjoRre4F1aVR1l1ORc9KVZZBR2EijDPxi2YcjZe2ayJZVqtYZs0XVJ3%2FxmqO8Y6GhyLGLE3wMqgKTLMd20CiZMFsUJhIQ6fs3VJj7Jcbt%2Bs%2BSuyUrbGFqhLZzw%2F28FeUm9P3zXj9DS4J3R8k7fopbbh%2BrNRcQdJDSH6KL8F9CsDnUTgKuDkiSsI48vAtyvm9nrQmcgbZQt5SQEmkIUrGb5GtZ%2FZOoYvQb7aVK9k2Gy0IskufzmXeyaQWR5AAz9Yqx%2FRf90wrtmiyKc2zCpnpECxOz22IspSbmrwJKc6a07Hu3FBA6l57KA8E2z1zcGEypEdMb%2BVHCYfbcpVojIp5ncLUibwU4bqTA8VDjM%2Fr%2BuINwxR7souYUKPbEnbvXlIOpf7YEY1UV2vNyrCqJ%2FMWB9gA3fsw6PiwmQY6qQEorrD%2B4lM9KtQarAE6NyY56c6QIa%2Bw%2BO9eei%2BxUFNmgKbD%2BQO%2FLwlDcT5mVzldfQr%2FYYhKYHYwdNsd%2ByuL25A%2Fz0tPe5Ce2S97JX8pa%2FqhvmgRvpYhpzNI6ti4474IzXfeZqmE0aHLvozn8rYuLQaIY6FC4KGyKhTvAEybwTl2awNAd8sykYfuPnZ7Tqq57VVxPOn4TLb8r8dEimZLkjYpR1K%2FWWNlc6ha&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20220922T123103Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=ASIAQ3PHCVTYVWGEM44X%2F20220922%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=7baf98ca5d8d69bdebd4369d7c96ea6fa60b833249d9b525d63c57e0893541c8&hash=b2681435248074b63bd876c93323950c2b27e4ee9c5275d38f7d2f67a86822b3&host=68042c943591013ac2b2430a89b270f6af2c76d8dfd086a07176afe7c76c2c61&pii=S1876610215013235&tid=spdf-06a33dde-f243-444b-8455-99df3f246479&sid=b3ed57525f92f143024878b224a44c50c5d4gxrqa&type=client&ua=5851050c51035200&rr=74eb0e2f2b4585a4

SIC_BAT = 500;

%SIC = SIC_PV + SIC_PEM + SIC_PE;            %Specific investment cost

%% OPERATION AND MAINTENANCE (OM)
% En porcentaje con respecto a Investment Cost

OM_PV = 0.02;                               %O&M PV
OM_PEM = 0.02;                              %O&M Electrolizador PEM
OM_PE = 0.02;                               %O&M Electronica de potencia
OM_BAT = 0.03;                              %O&M Bateria

OM = OM_PV + OM_PEM + OM_PE + OM_BAT;       %operation and maintenance

%% INVERSION INICIAL (INVEST)(CAPEX)
%INVEST = SIC * INP_PV + SIC_BAT * INP_BAT;
INVEST = SIC_PV * INP_PV + SIC_PE * INP_PV + SIC_PEM * INP_E + SIC_BAT * INP_BAT;

%% OPEX
OPEX = (OM_PV * SIC_PV * INP_PV) + (OM_PE * SIC_PE * INP_PV) + (OM_PEM * SIC_PEM * INP_E) + (OM_BAT * SIC_BAT * INP_BAT);

%% ANN

i = 0.07;
n = 25;
ANN = (((1+i)^n)*i)/(((1+i)^n)-1);

%% COSTO ANUAL TOTAL
TAC = ANN*INVEST + OPEX;

%% PRODUCION ANUAL DE HIDROGENO (AHP) en kg
%AHP = 3000;  %Annual hydrogen production

%% LCOH
% Al 2022, el LCOH mundia varia entre 1,6 y 10,4 USD/kg
LCOH_EURO = TAC/AHP;
LCOH_USD = LCOH_EURO*0.99;
LCOH = LCOH_USD;
