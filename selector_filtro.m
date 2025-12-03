function selector_filtro()
    % Crear la ventana principal
    fig = uifigure('Name', 'Selector de Filtros', 'Position', [100 100 350 250]);

    % Etiqueta del título
    titleLabel = uilabel(fig, 'Text', 'Seleccione el Tipo de Filtro', ...
                         'Position', [50 170 250 40], 'FontSize', 16, 'FontWeight', 'bold', ...
                         'HorizontalAlignment', 'center');
    
    % Desplegable para seleccionar tipo de filtro
    filterLabel = uilabel(fig, 'Text', 'Tipo de Filtro:', 'Position', [50 120 120 30]);
    filterType = uidropdown(fig, 'Position', [180 125 150 30], ...
                            'Items', {'Butterworth', 'Chebyshev Tipo I', 'Chebyshev Tipo II'});
    
    % Botón para continuar
    continueButton = uibutton(fig, 'Text', 'Configurar Filtro', ...
                              'Position', [75 50 200 50], 'ButtonPushedFcn', @(btn, event)abrirVentanaFiltro());

    % Función para abrir la ventana correcta
    function abrirVentanaFiltro()
        tipo = filterType.Value;
        close(fig); % Cerrar la ventana de selección
        
        switch tipo
            case 'Butterworth'
                filtro_butterworth_interactivo();
            case 'Chebyshev Tipo I'
                filtro_chebyshev_interactivo('Tipo I');
            case 'Chebyshev Tipo II'
                filtro_chebyshev_interactivo('Tipo II');
        end
    end
end
