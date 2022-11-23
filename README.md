# MemoriaPregrado
Códigos de matlab para analisis de datos de memoria de pregrado "SISTEMA HÍBRIDO PV CON ALMACENAMIENTO DE ENERGÍA PARA PRODUCCIÓN DE HIDRÓGENO VERDE OFF-GRID" 

Los archivos Perfil1, Perfil2, Perfil3, Perfil4, Perfil5, Perfil6 contienen el analisis de un dia para los distintos escenarios, siendo este dia modificable. Entrega Npv y Cpv para los distintos escenarios. Lo utilice mas que nada para empezar, y para el analisis grafico, ya que los verdaderos resultados no estan aca.

Los archivos Perfil1_365, Perfil2_365, Perfil3_365, Perfil4_365, Perfil5_365, Perfil6_365 contienen el mismo analisis que los archivos anteriores, pero utilizando todos los datos de irradiacion y temperatura entregados por el archivo Antofagasta_data_daily, los cuales corresponden a un año, pero se termina utilizando 357 dias. Estos archivos entregan los vectores N_pv365, Bateria365 y Potencia 365, los cuales contienen para cada escenario el numero de paneles, la capacidad de bateria necesaria y la potencia generada por el arreglo PV.


Los archivos Analisis_365_1, Analisis_365_2, Analisis_365_3, Analisis_365_4, Analisis_365_5, Analisis_365_6 toma como entrada los archivos generados por los script anteriores, elimina los dias que tienen dias con datos defectuosos, aplica distribucion gama sobre cada escenario, como perdidas e ineficiencias. Entrega el LCOH..

Para la utilizacion de los archivos anteriores se crean las funciones; PV que contiene el modelo PV, el cual tiene como entrada la temperatura, irradiacion y voltaje de un instante dado, y entrega la corriente generada por el panel; P_PV entrega la potencia maxima que se puede obtener de PV en un instante dado; LCOH que entrega el costo nivelado del hidrogeno, teniendo como entradas el tamaño del sistema PV en [W], la capacidad de la bateria en [Wh], la potencia del electrolizador en [W] y la cantidad de hidrogeno producido en un año por cada escenario.
