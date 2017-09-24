<h1 align="center">
  <img alt="Espectro respuesta" src="http://ppizarror.com/resources/other/matlab.png" width="200px" height="200px" />
  <br /><br />
  Espectro respuesta</h1>
<p align="center">Calcula el espectro de respuesta a partir de un registro de aceleración</p>
<div align="center"><a href="http://ppizarror.com"><img alt="@ppizarror" src="http://ppizarror.com/badges/autor.svg" /></a>
<a href="https://www.gnu.org/licenses/old-licenses/gpl-2.0.html"><img alt="GPL V2.0" src="http://ppizarror.com/badges/licenciagpl2.svg" /></a>
</div><br />

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

## Autor
<a href="http://ppizarror.com" title="ppizarror">Pablo Pizarro R.</a> | 2017
