# Estado del acceso a internet

En este proyecto, se realizó un análisis descriptivo para determinar el estado del acceso a Internet en las provincias de Argentina. Además, se diseñó un dashboard para presentar los resultados principales, y se propusieron 3 KPIs (Indicadores Clave de Desempeño).

Los archivos encontrados en este repositorio son: 
- 5 Archvos `.csv` con información procesada para el diseño del dashboard.
- El archivo `AnalystComunication.ipynb` que tiene todo el analisis descriptivo.
- El archivo `app.R` que tiene el dashboard implementado en `R`, en específico se usó la librería `shiny`.
- La carpeta `www` que contiene una imagen usada como logo en el dashboard.

# Resultados principales 
Encontró que el acceso a internet banda ancha fijo ha estado en aumento en los últimos años, en comparación con el acceso a internet Dial-up el cual presenta una disminución constante desde 2014. 

![](https://github.com/Diegocal82/DataSciCom/blob/main/Images/lineas.png)

Se crearon gráficos de líneas para cada una de las series analizadas. Se pudo observar una tendencia lineal inversa entre los servicios de internet, lo cual indica que hay una relación inversa entre el uso de banda ancha y el uso de Dial-up. Sin embargo, en el caso del PIB per cápita, no se identificó una tendencia clara. A pesar de ello, se pudo concluir que independientemente de las fluctuaciones en esta medida, el acceso y posiblemente la demanda de servicios de internet continúan aumentando.Esto sugiere que el internet se ha convertido en un servicio básico y necesario para las personas, y que, sin importar sus ingresos, optan por adquirir servicios de internet, principalmente de banda ancha.

![](https://github.com/Diegocal82/DataSciCom/blob/main/Images/LineasA.png)

En el gráfico anterior, se muestran los anchos de banda máximos (30 Mbps) y mínimos (512 Kbps) que son ofrecidos comúnmente. En los últimos años, se ha observado un crecimiento en la demanda de anchos de banda superiores a 30 Mbps, lo cual sugiere que los usuarios prefieren un servicio más rápido y eficiente, aun cuando implique un costo ligeramente más elevado (ya que los anchos de banda mayores tienden a ser más costosos). Esta tendencia indica que los usuarios valoran la calidad del servicio y están dispuestos a invertir un poco más para obtener una conexión más rápida y confiable en lugar de optar por una opción más económica pero más lenta.

# Indicadores Clave de Desempeño (KPI)
Se eligeron 3 KPIs que englobaran el fenómeno en estudio:
- Porcentaje de retención de clientes en el servicio: Porcentaje de clientes que siguen utilizando los servicios de telecomunicaciones durante el período de tiempo analizado, el calculo se hizo usando el acceso por tipo de conexión y el total de acceso nacional.
  
- Porcentaje de ancho de banda disponible: Capacidad máxima de transmisión de datos en una red. Se mide en bits por segundo (bps) o sus múltiplos (Kbps, Mbps, Gbps, etc.). Con este KPI se quiso medir la disponibildad de la trasmisión de datos durante el periodo analzado, el calculo se hizo usando el acceso por tipo banda y el total de acceso de todas las bandas.
  
- Tecnologia disponible por Provincia: La tecnologia presente para acceso a internet, esta limita la velocidad de trasmisñon de datos. Este se evaluo verificando si estaba o no la tecnología en la provincia.

Estas se implemtaron en un Dashboard usando `R` con el paquete `shiny`.

![](https://github.com/Diegocal82/DataSciCom/blob/main/Images/DashM.png)




