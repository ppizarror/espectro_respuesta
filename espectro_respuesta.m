function [Sd, Sv, Sa, T, TTT] = espectro_respuesta(acc, Fs, beta, varargin)
% Crea el espectro de respuesta a partir de un registro de aceleraciones.
%
% Input:
%   acc:            Vector de aceleraciones en cm*s^2
%   Fs:             Numero de muestras por segundo
%   beta:           Razon de amortiguamiento
%
% Parametros opcionales:
%   accdetrend      Aplica detrend al vector de entrada de aceleracion
%   dogrid          Muestra la leyenda
%   dohold          Muestra la leyenda
%   dt              Delta de periodo (s)
%   figid           Numero de la figura
%   gcm2            Unidad de conversion entre (g) y (cm/s2)
%   plot            Indica si grafica o no (booleano)
%   plotcolor       Color de la linea
%   plotlegend      Leyenda del plot, por defecto se escribe el valor de beta
%   plotlog         Grafica en log eje x
%   plottitle       Titulo del plot
%   salabel         Etiqueta eje y aceleracion
%   sdlabel         Etiqueta eje y desplazamiento
%   showlegend      Muestra la leyenda
%   svlabel         Etiqueta eje y velocidad
%   tf              Periodo final de analisis (s)
%   ti              Periodo inicial de analisis (s)
%   xlabel          Etiqueta eje x periodo
%
% Output:
%   Sd:             Vector desplazamiento (cm)
%   Sv:             Vector de velocidad (cm/s)
%   Sa:             Vector de aceleracion (cm/s2)
%   T:              Vector de periodo (s)
%   TTT:            Tiempo asociado a la maxima aceleracion
%
% Ejemplo de uso:
%   1) [Sd, Sv, Sa, T, ~] = espectro_respuesta(data, fs, 0.05, 'plot', true, ...
%       'figid', 1, 'plotcolor', 'r');
%   2) espectro_respuesta(data, fs, 0.05, 'plot', true);
%   3) [Sd, Sv, Sa, T, TTT] = espectro_respuesta(data, fs, 0.05);
%   4) [Sd, Sv, Sa, ~] = espectro_respuesta(data, fs, 0.05, 'plot', true);
%   5) espectro_respuesta(data, fs, 0.02, 'plot', true, 'plotlog', false);
%
% Autor: Pablo Pizarro R. @ ppizarror.com
% Version: 3.0 (22/11/2020)
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

% Recorre parametros opcionales
p = inputParser;
p.KeepUnmatched = true;
addOptional(p, 'accdetrend', false);
addOptional(p, 'dogrid', true);
addOptional(p, 'dohold', true);
addOptional(p, 'dt', 0.005);
addOptional(p, 'figid', 0);
addOptional(p, 'gcm2', 9.80665*100);
addOptional(p, 'plot', false);
addOptional(p, 'plotcolor', 'k-');
addOptional(p, 'plotlegend', '');
addOptional(p, 'plotlog', true);
addOptional(p, 'plottitle', 'Espectro de respuesta');
addOptional(p, 'salabel', '$S_A (g)$');
addOptional(p, 'sdlabel', '$S_D (cm)$');
addOptional(p, 'showlegend', true);
addOptional(p, 'svlabel', '$S_V (cm/s)$');
addOptional(p, 'tf', 10);
addOptional(p, 'ti', 0.01);
addOptional(p, 'xlabel', 'Periodo $(s)$');
parse(p, varargin{:});
r = p.Results;

if ~isnumeric(Fs)
    error('Fs debe ser un numero, no un vector');
end
if ~isnumeric(beta)
    error('beta debe ser un numero, no un vector');
end

%% Se aplica correccion de linea base
acc = real(acc);
if r.accdetrend
    acc = detrend(acc);
end

%% Crea arreglos de tiempo y razon de amortiguamiento
T = r.ti:r.dt:r.tf; % Vector de periodo

%% Dimensiones
nT = length(T);

%% Inicializacion de variables
Sd = zeros(nT, 1); % Vector de ceros para iniciar vectores de desplazamiento
Sa = zeros(nT, 1); % Vector de ceros para iniciar vectores de aceleracion
Sv = zeros(nT, 1); % Vector de ceros para iniciar vectores de velocidad
TTT = zeros(nT, 1); % Tiempos de maxima aceleracion para cada combinacion amortiguamiento-tiempo

%% Se recorre cada combinacion de amortiguamiento-periodo
for i = 1:nT
    % Se obtiene desplazamiento, velocidad y aceleracion
    [xm, vm, am] = respcacr(1, T(i), beta, -acc, Fs, 0, 0);

    % Se guarda el maximo desplazamiento
    Sd(i) = max(abs(xm));

    % Se guarda la maxima velocidad
    Sv(i) = max(abs(vm));

    % Se guarda la maxima aceleracion, suma movimiento de la base
    Sa(i) = max(abs(am+acc));

    % Tiempo asociado a la maxima aceleracion
    TTT(i) = max_t(am, Fs);
end

%% Grafica los resultados
if r.plot
    r.figid = fix(r.figid); % Convierte a numero entero
    if r.figid <= 0
        fig = figure();
    else
        fig = figure(r.figid);
    end
    set(gcf, 'name', r.plottitle);
    movegui(fig, 'center');
    
    % Grafica pseudoespectro de desplazamiento
    subplot(3, 1, 1);
    if ~strcmp(r.plotlegend, '')
        if r.plotlog
            semilogx(T, Sd, r.plotcolor, 'DisplayName', r.plotlegend);
        else
            plot(T, Sd, r.plotcolor, 'DisplayName', r.plotlegend);
        end
    else
        if r.plotlog
            semilogx(T, Sd, r.plotcolor, 'DisplayName', strcat('\beta=', num2str(beta)));
        else
            plot(T, Sd, r.plotcolor, 'DisplayName', strcat('\beta=', num2str(beta)));
        end
    end
    if r.showlegend
        legend(gca, 'show');
    end
    if r.dohold
        hold on;
    else
        hold off;
    end
    if r.dogrid
        grid on;
    else
        grid off;
    end
    title(r.plottitle);
    ylabel(r.sdlabel, 'Interpreter', 'latex');
    
    % Grafica pseudoespectro de velocidad
    subplot(3, 1, 2);
    if r.plotlog
        semilogx(T, Sv, r.plotcolor);
    else
        plot(T, Sv, r.plotcolor);
    end
    if r.dohold
        hold on;
    else
        hold off;
    end
    if r.dogrid
        grid on;
    else
        grid off;
    end
    ylabel(r.svlabel, 'Interpreter', 'latex');
    
    % Grafica pseudoespectro de aceleracion
    subplot(3, 1, 3);
    if r.plotlog
        semilogx(T, Sa./r.gcm2, r.plotcolor);
    else
        plot(T, Sa./r.gcm2, r.plotcolor);
    end
    if r.dohold
        hold on;
    else
        hold off;
    end
    if r.dogrid
        grid on;
    else
        grid off;
    end
    ylabel(r.salabel, 'Interpreter', 'latex');
    xlabel(r.xlabel, 'Interpreter', 'latex');
end

function [t] = max_t(columna, Fs)
% max_t: Entrega la posicion del maximo
m = size(columna);
a = 0;
for i = 1:m
    if abs(a) < abs(columna(i))
        a = abs(columna(i));
        t = i / Fs;
    end
end

function [x, v, a] = respcacr(m, T, b, P, Fs, xo, vo)
% respcacr: Genera respuesta de un oscilador linear estable paso a paso
% metodo de aceleracion constante. SUPONE 1 GDL.
% Metodo incondicionalmente estable autoiniciante. Por precision
% se recomienda que Fs > 10/T. OJO USA LTILR: ES MAS RAPIDO
%
% Input
%   m:      Masa del sistema
%   T:      Periodo no amortiguado del oscilador sec
%   b:      Razon amortigumiento critico
%   P:      Registro de excitacion (-m*vg si es ac.)
%   Fs:     Frecuencia muestreo en registro aceleracion
%   xo:     Desplazamiento inicial
%   vo:     Velocidad inicial
%
% Output
%	x:		Vector desplazamiento
%	v:		Vector velocidad
%	a:		Vector de aceleracion

%% Se crea la ecuacion de un oscilador armonico de 1 grado de libertad
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

% Ecuacion de rigidez, k*
kk = (4 * m) / dt2 + 2 / dt * c + k;

% Calcula la inversa
ikk = inv(kk);

ao = (P(1) - c * vo - k * xo) / m; % Expresion de fuerza
P = [P(2:np); P(np)]; % Elimina el primer elemento y repite el ultimo

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