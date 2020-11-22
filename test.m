fs = 100; % Muestreo por segundo
data = detrend(load('accRoca.txt'), 0); % En (g)

[Sd, Sv, Sa, ~] = espectro_respuesta(data.*980, fs, 0.05, 'plot', true, 'figid', 1, ...
    'plottitle', 'Espectro de respuesta', 'plotcolor', 'r', 'plotlog', true);

clear FS data;