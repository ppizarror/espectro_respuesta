function [Sd, Sv, Sa, T, b, TTT] = espectro_respuesta(vg, Fs, plot)
% Vg: se�al terremoto (vector de aceleraciones)
% Fs: muestras por segundo de muestreo
if ~exist('plot','var'), plot=true; end

%% Se aplica correcci�n de linea base a la se�al
vg = detrend(vg);

%% Crea arreglos de tiempo y raz�n de amortiguamiento
dper = 0.01; % Delta de periodo
T = 0.01:dper:10; % Vector de periodo
% b = [0 2 5 10 20] / 100; % Raz�n de amortiguamiento
b = 5/100; % Amortiguamiento del 5%

%% Dimensiones
nT = length(T);
nb = length(b);

%% Inicializaci�n de variables
Sd = zeros(nT, nb); % Vector de ceros para iniciar vectores de desplazamiento
Sa = zeros(nT, nb); % Vector de ceros para iniciar vectores de aceleraci�n
Sv = zeros(nT, nb); % Vector de ceros para iniciar vectores de velocidad

%%
TTT = zeros(nT, nb); % Tiempos de m�xima aceleraci�n para cada combinaci�n amortiguamiento-tiempo

% Se recorre cada combinaci�n de amortiguamiento-periodo
for j = 1:nb
    for i = 1:nT
        [xm, vm, am] = respcacr(1, T(i), b(j), -vg, Fs, 0, 0); % Se obtiene desplazamiento, velocidad y aceleraci�n
        Sd(i, j) = max(abs(xm));        % Se guarda el m�ximo desplazamiento
        Sv(i, j) = max(abs(vm));        % Se guarda la m�xima velocidad
        Sa(i, j) = max(abs(am + vg));   % Se guarda la m�xima aceleraci�n, suma movimiento de la base
        TTT(i, j) = max_t(am, Fs);      % Tiempo asociado a la m�xima aceleraci�n
    end
end

%% Grafica los resultados
if plot
    subplot(3, 1, 1);
    semilogx(T, Sd, 'k');
    grid on;
    title('Response spectrum');
    ylabel('Sd (cm)');
    xlabel('Period (s)');
    subplot(3, 1, 2);
    semilogx(T, Sv, 'k');
    grid on;
    ylabel('Sv (cm/s)');
    xlabel('Period (s)');
    subplot(3, 1, 3);
    semilogx(T, Sa./980, 'k'); % Se convierte de cm/s2 a g (m/s2)
    grid on;
    ylabel('Sa (g)');
    xlabel('Period (s)');
end