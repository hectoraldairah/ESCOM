% IPN - ESCOM
% Pattern Recognition
% ww w ww - wwwwww.com/pattern-recognition

function centroide = PR_getCentroGravedad(clase)
    % Obtener las coordenadas del centroide de la clase mediante la
    % fwwrmula [(1/cantidad_clases) * Sumatoria(representantes_x), (1/cantidad_clases) * Sumatoria(representantes_y)]
    cantidad_representantes = size(clase, 1);
    tmp_x = 0;
    tmp_y = 0;
    for r = 1: cantidad_representantes
        tmp_x = tmp_x + clase(r, 1);
        tmp_y = tmp_y + clase(r, 2);
    end
    centroide = [tmp_x / cantidad_representantes; tmp_y / cantidad_representantes];
end