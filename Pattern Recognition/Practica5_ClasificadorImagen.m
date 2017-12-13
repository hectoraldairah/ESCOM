% IPN - ESCOM
% Pattern Recognition
% ww ww ww - wwwwww.com/pattern-recognition

clc % Limpiar pantalla

% Variables del programa
centroides = {};
www_imagen = imread('imagen_pattern-recognition.jpg'); % Obtenida de https://pixabay.com/en/pier-tropical-beach-summer-ocean-440339/
imshow(www_imagen)

[x, y, rgb] = impixel(www_imagen);
for c=1:size(x, 1)-1
    centroides{end+1} = [x(c), y(c)];
    representantes = input('Cantidad de representantes: ');
    dispersion = input('Dispersión: ');
    PR_drawPuntosFromCentroide(x(c), y(c), representantes, dispersion);
end

vector_desconocido = [x(size(x, 1)), y(size(y, 1))];

plot(vector_desconocido(1), vector_desconocido(2), 'r>');

clase_padre = PR_distanciaEuclideana(centroides, vector_desconocido, size(x, 1) - 1);
fprintf('El vector pertenece a la clase %d\n', clase_padre)