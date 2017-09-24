Código en Matlab que calcula el espectro de respuesta a partir de un registro de aceleraciones

## Modo de uso
```matlab
[Sd, Sv, Sa, T, b, TTT] = espectro_respuesta(vg, Fs, plot)
```

**Entrada**:

| Variable | Descripción |
| :-: | :--|
| vg | Vector de aceleraciones (g) |
| Fs | Número de muestras por segundo |
| plot | Indica si crea un gráfico a partir de los resultados (true, false) |

**Salida**:

| Variable | Descripción |
| :-: | :--|
| Sd | Vector desplazamiento |
| Sv | Vector de velocidad |
| Sa | Vector de aceleración |
| T | Vector período |
| b | Amortiguamiento |
    
## Licencia
Este proyecto está licenciado bajo GPLv2 [https://www.gnu.org/licenses/gpl-2.0.html]