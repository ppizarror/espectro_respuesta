function [Sd, Sv, Sa, T, TTT] = espectro_respuesta(acc, Fs, beta, plot, figid, plottitle, plotcolor, showlegend, dohold, dogrid, plotlegend)
% [Sd, Sv, Sa, T, TTT] = espectro_respuesta(acc, Fs, beta)
% [Sd, Sv, Sa, T, TTT] = espectro_respuesta(acc, Fs, beta, true)
% [Sd, Sv, Sa, T, TTT] = espectro_respuesta(acc, Fs, beta, true, figid, plottitle)
% [Sd, Sv, Sa, T, TTT] = espectro_respuesta(acc, Fs, beta, true, figid, plottitle, plotcolor)
% [Sd, Sv, Sa, T, TTT] = espectro_respuesta(acc, Fs, beta, true, figid, plottitle, plotcolor, showlegend, dohold, dogrid)
%
% Crea el espectro de respuesta a partir de un registro de aceleraciones.
%
% Autor: Pablo Pizarro R. @ ppizarror.com
% Versión: 2.3 (27/09/2017)
% Licencia: GPLv2
%	This program is free software; you can redistribute it and/or
%	modify it under the terms of the GNU General Public License
%	as published by the Free Software Foundation; either version 2
%	of the License, or (at your option) any later version.
%
% 	This program is distributed in the hope that it will be useful,
% 	but WITHOUT ANY WARRANTY; without even the implied warranty of
% 	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% 	GNU General Public License for more details.
%
% 	You should have received a copy of the GNU General Public License
% 	along with this program; if not, write to the Free Software
% 	Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA
%
% Input:
%   acc:        Vector de aceleraciones en cm*s^2
%   Fs:         Número de muestras por segundo
%   beta:       Razón de amortiguamiento
%   plot:       Indica si grafica o no (booleano)
%   plottitle:  Título del plot
%   plotcolor:  Color de la línea
%   figid:      Número de la figura
%   showlegend: Muestra la leyenda
%   dohold:     Muestra la leyenda
%   dogrid:     Muestra la leyenda
%   plotlegend: Leyenda del plot, por defecto se escribe el valor de beta
%
% Output:
%   Sd:         Vector desplazamiento
%   Sv:         Vector de velocidad
%   Sa:         Vector de aceleración
%   T:          Vector de período
%   TTT:        Tiempo asociado a la máxima aceleración

%% Si no se define plot
if ~exist('plot', 'var'), plot = false; end
if ~exist('plottitle', 'var'), plottitle = ''; end
if ~exist('plotcolor', 'var'), plotcolor = 'k-'; end
if ~exist('showlegend', 'var'), showlegend = false; end
if ~exist('dohold', 'var'), dohold = true; end
if ~exist('dogrid', 'var'), dogrid = true; end
if ~exist('plotlegend', 'var'), plotlegend = ''; end

%% Se aplica corrección de linea base a la señal
acc = detrend(acc);

%% Crea arreglos de tiempo y razón de amortiguamiento
dper = 0.01; % Delta de periodo
T = 0.01:dper:10; % Vector de periodo

%% Dimensiones
nT = length(T);
nb = length(beta);

%% Inicialización de variables
Sd = zeros(nT, nb); % Vector de ceros para iniciar vectores de desplazamiento
Sa = zeros(nT, nb); % Vector de ceros para iniciar vectores de aceleración
Sv = zeros(nT, nb); % Vector de ceros para iniciar vectores de velocidad
TTT = zeros(nT, nb); % Tiempos de máxima aceleración para cada combinación amortiguamiento-tiempo

%% Se recorre cada combinación de amortiguamiento-periodo
for j = 1:nb
    for i = 1:nT
        % Se obtiene desplazamiento, velocidad y aceleración
        [xm, vm, am] = respcacr(1, T(i), beta(j), -acc, Fs, 0, 0);
        
        % Se guarda el máximo desplazamiento
        Sd(i, j) = max(abs(xm));
        
        % Se guarda la máxima velocidad
        Sv(i, j) = max(abs(vm));
        
        % Se guarda la máxima aceleración, suma movimiento de la base
        Sa(i, j) = max(abs(am+acc));
        
        % Tiempo asociado a la máxima aceleración
        TTT(i, j) = max_t(am, Fs);
    end
end

%% Grafica los resultados
if plot
    if ~exist('figid', 'var')
        fig = figure();
    else
        fig = figure(figid);
    end
    set(gcf, 'name', plottitle);
    movegui(fig, 'center');
    subplot(3, 1, 1);
    if plotlegend ~= ''
        semilogx(T, Sd, plotcolor, 'DisplayName', plotlegend);
    else
        semilogx(T, Sd, plotcolor, 'DisplayName', strcat('\beta=', num2str(beta)));
    end
    if showlegend && plotlegend ~= ''
        legend(gca, 'show');
    end
    if dohold
        hold on;
    else
        hold off;
    end
    if dogrid
        grid on;
    else
        grid off;
    end
    title(plottitle);
    ylabel('$S_D (cm)$', 'Interpreter', 'latex');
    xlabel('Periodo $(s)$', 'Interpreter', 'latex');
    subplot(3, 1, 2);
    semilogx(T, Sv, plotcolor);
    if dohold
        hold on;
    else
        hold off;
    end
    if dogrid
        grid on;
    else
        grid off;
    end
    ylabel('$S_V (cm/s)$', 'Interpreter', 'latex');
    xlabel('Periodo $(s)$', 'Interpreter', 'latex');
    subplot(3, 1, 3);
    semilogx(T, Sa./980, plotcolor);
    if dohold
        hold on;
    else
        hold off;
    end
    if dogrid
        grid on;
    else
        grid off;
    end
    ylabel('$S_A (g)$', 'Interpreter', 'latex');
    xlabel('Periodo $(s)$', 'Interpreter', 'latex');
end

function [t] = max_t(columna, Fs)
m = size(columna);
a = 0;
for i = 1:m
    if abs(a) < abs(columna(i))
        a = abs(columna(i));
        t = i / Fs;
    end
end

function [x, v, a] = respcacr(m, T, b, P, Fs, xo, vo)
% Genera respuesta de un oscilador linear estable paso a paso
% método de aceleracion constante. SUPONE 1 GDL.
% Metodo incondicionalmente estable autoiniciante. Por precisión
% se recomienda que Fs > 10/T. OJO USA LTILR: ES MAS RÁPIDO
%
% Input
%   m:      Masa del sistema
%   T:      Período no amortiguado del oscilador sec
%   b:      Razón amortigumiento critico
%   P:      Registro de excitación (-m*vg si es ac.)
%   Fs:     Frecuencia muestreo en registro aceleracion
%   xo:     Desplazamiento inicial
%   vo:     Velocidad inicial
%
% Output
%	x:		Vector desplazamiento
%	v:		Vector velocidad
%	a:		Vector de aceleración

%% Se crea la ecuación de un oscilador armónico de 1 grado de libertad
np = length(P);
dt = 1 / Fs;
dt2 = dt * dt;
if m > 0
    w = 2 * pi / T;
    k = m * w * w;
    c = 2 * m * w * b;
else
    k = T;
    c = b;
    m = abs(m);
end

% Ecuación de rigidez, k*
kk = (4 * m) / dt2 + 2 / dt * c + k;

% Calcula la inversa
ikk = inv(kk);

ao = (P(1) - c * vo - k * xo) / m; % Expresión de fuerza
P = [P(2:np); P(np)]; % Elimina el primer elemento y repite el último

dt24 = 4 / dt2;
km = ikk * m; %#ok<*MINV>
mdt24 = km * 4 / dt2;
dt14 = 4 / dt;
mdt14 = ikk * m * 4 / dt;
dt12 = 2 / dt;
kc = ikk * c;
cdt12 = kc * 2 / dt;

AA = [mdt24 + cdt12, mdt14 + ikk * c, km; ...
    dt12 * (mdt24 + cdt12) - dt12, dt12 * (mdt14 + ikk * c) - 1, dt12 * km; ...
    dt24 * (mdt24 + cdt12) - dt24, dt24 * (mdt14 + ikk * c) - dt14, dt24 * km - 1];
BB = [ikk, ikk * dt12, ikk * dt24].';

% Computa el tiempo de respuesta de AAx[t] + BB*P[t]
xx = ltitr(AA, BB, P, [xo, vo, ao].');
a = [xx(:, 3)]; %#ok<*NBRAK>
v = [xx(:, 2)];
x = [xx(:, 1)];