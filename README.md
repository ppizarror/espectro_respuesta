# Espectro respuesta
[![@ppizarror](http://ppizarror.com/resources/images/autor.svg)](http://ppizarror.com)
[![Licencia GPL](http://ppizarror.com/resources/images/licenciagpl2.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html)

Código en Matlab que calcula el espectro de respuesta a partir de un registro de aceleraciones.

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

## Autor
<a href="http://ppizarror.com">Pablo Pizarro R.</a> | 2017.<br>
Agradecimientos a Felipe Ochoa.