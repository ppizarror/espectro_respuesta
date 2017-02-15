function [t]=max_t(columna, Fs)
% Retorna el tiempo asociado a la m�xima aceleraci�n calculada por el
% oscilador para un tiempo y una raz�n de amortiguamiento.

m=size(columna);
a=0;
for i=1:m
    % Almacena la m�xima aceleraci�n y guarda el tiempo asociado
    if abs(a) < abs(columna(i))
        a = abs(columna(i));
        t = i/Fs;
    end
end