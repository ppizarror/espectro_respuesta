function [Sd, Sv, Sa, T, b, TTT] = espectro_respuesta(vg, Fs, b, plot, plottitle)
% Crea el espectro de respuesta a partir de un registro de aceleraciones.
%
% Input:
%   Vg:         Señal terremoto (vector de aceleraciones)
%   Fs:         Número de muestras por segundo
%   b:          Razón de amortiguamiento
%   plot:       Indica si grafica o no (booleano)
%   plottitle:  Título del plot
%
% Output:
%   Sd: Vector desplazamiento
%   Sv: Vector de velocidad
%   Sa: Vector de aceleración
%   T: Vector período
%   b: Amortiguamiento

function [t] = max_t(columna, Fs)
% Retorna el tiempo asociado a la máxima aceleración calculada por el
% oscilador para un tiempo y una razón de amortiguamiento.

m = size(columna);
a = 0;
for i = 1:m
    % Almacena la máxima aceleración y guarda el tiempo asociado
    if abs(a) < abs(columna(i))
        a = abs(columna(i));
        t = i / Fs;
    end
end

%% Si no se define plot se deja falso
if ~exist('plot', 'var'), plot = false; end

%% Se aplica corrección de linea base a la señal
vg = detrend(vg);

%% Crea arreglos de tiempo y razón de amortiguamiento
dper = 0.01; % Delta de periodo
T = 0.01:dper:10; % Vector de periodo

%% Dimensiones
nT = length(T);
nb = length(b);

%% Inicialización de variables
Sd = zeros(nT, nb); % Vector de ceros para iniciar vectores de desplazamiento
Sa = zeros(nT, nb); % Vector de ceros para iniciar vectores de aceleración
Sv = zeros(nT, nb); % Vector de ceros para iniciar vectores de velocidad
TTT = zeros(nT, nb); % Tiempos de máxima aceleración para cada combinación amortiguamiento-tiempo

%% Se recorre cada combinación de amortiguamiento-periodo
for j = 1:nb
    for i = 1:nT
        % Se obtiene desplazamiento, velocidad y aceleración
        [xm, vm, am] = respcacr(1, T(i), b(j), -vg, Fs, 0, 0);
        
        % Se guarda el máximo desplazamiento
        Sd(i, j) = max(abs(xm));
        
        % Se guarda la máxima velocidad
        Sv(i, j) = max(abs(vm));
        
        % Se guarda la máxima aceleración, suma movimiento de la base
        Sa(i, j) = max(abs(am+vg));
        
        % Tiempo asociado a la máxima aceleración
        TTT(i, j) = max_t(am, Fs);
    end
end

%% Grafica los resultados
if plot
    figure('name', plottitle);
    subplot(3, 1, 1);
    semilogx(T, Sd, 'k');
    grid on;
    title(plottitle);
    ylabel('$S_D (cm)$', 'Interpreter', 'latex');
    xlabel('Periodo $(s)$', 'Interpreter', 'latex');
    subplot(3, 1, 2);
    semilogx(T, Sv, 'k');
    grid on;
    ylabel('$S_V (cm/s)$', 'Interpreter', 'latex');
    xlabel('Periodo $(s)$', 'Interpreter', 'latex');
    subplot(3, 1, 3);
    semilogx(T, Sa./980, 'k');
    grid on;
    ylabel('$S_A (g)$', 'Interpreter', 'latex');
    xlabel('Periodo $(s)$', 'Interpreter', 'latex');
end