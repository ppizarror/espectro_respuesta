Código en Matlab que calcula el espectro de respuesta a partir de un registro de aceleraciones.

## Modo de uso
```matlab
[Sd, Sv, Sa, T, TTT] = espectro_respuesta(acc, Fs, beta, plot, figid, plottitle, plotcolor, showlegend, dohold, dogrid)
```

**Entrada**:

| Variable | Descripción |
| :-: | :--|
| acc | Vector de aceleraciones (cm*s^2) |
| Fs | Número de muestras por segundo |
| beta | Razón de amortiguamiento |
| plot | Indica si grafica o no (```false``` por defecto) |
| figid | Número de la figura |
| plottitle | Título del plot |
| plotcolor | Color de la línea (```'k'``` por defecto) |
| showlegend | Muestra la leyenda (```false``` por defecto)|
| dohold | hold en cada gráfico (```true``` por defecto)|
| dogrid | grid en cada grafico (```true``` por defecto)|

**Salida**:

| Variable | Descripción |
| :-: | :--|
| Sd | Vector desplazamiento |
| Sv | Vector de velocidad |
| Sa | Vector de aceleración |
| TTT | Tiempo asociado a la máxima aceleración |
    
## Licencia
Este proyecto está licenciado bajo GPLv2 [https://www.gnu.org/licenses/gpl-2.0.html]