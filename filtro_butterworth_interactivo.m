function filtro_butterworth_interactivo()
    % Crear la ventana principal
    fig = uifigure('Name', 'Configurador de Filtro Butterworth', ...
                   'Position', [100 100 400 500]);

    % Etiqueta del título
    uilabel(fig, 'Text', 'Configurador de Filtro Butterworth', ...
            'Position', [50 450 300 40], 'FontSize', 16, ...
            'FontWeight', 'bold', 'HorizontalAlignment', 'center');

    % Desplegable para seleccionar tipo de filtro
    uilabel(fig, 'Text', 'Tipo de Filtro:', 'Position', [50 400 100 30]);
    filterType = uidropdown(fig, 'Position', [160 405 180 30], ...
                            'Items', {'Pasa bajos', 'Pasa altos', ...
                                      'Pasa banda', 'Elimina banda'});

    % Orden
    uilabel(fig, 'Text', 'Orden del Filtro:', 'Position', [50 350 100 30]);
    orderField = uieditfield(fig, 'numeric', ...
                             'Position', [160 355 180 30], ...
                             'Limits', [1 Inf], 'Value', 4);

    % Frecuencia(s) de corte
    uilabel(fig, 'Text', 'Frecuencia(s) de Corte (Hz):', ...
            'Position', [50 300 200 30]);
    cutoffField = uieditfield(fig, 'text', ...
                              'Position', [250 305 90 30], ...
                              'Value', '1000');

    % Frecuencia de muestreo
    uilabel(fig, 'Text', 'Frecuencia de Muestreo (Hz):', ...
            'Position', [50 250 200 30]);
    fsField = uieditfield(fig, 'numeric', ...
                          'Position', [250 255 90 30], ...
                          'Limits', [1 Inf], 'Value', 8000);

    % Modo de visualización
    uilabel(fig, 'Text', 'Modo de Visualización:', ...
            'Position', [50 200 150 30]);
    outputMode = uidropdown(fig, 'Position', [250 205 120 30], ...
                            'Items', {'Ventana Independiente', ...
                                      'Herramienta MATLAB (fvtool)'});

    % Botón
    uibutton(fig, 'Text', 'Generar Filtro', ...
             'Position', [100 130 200 40], ...
             'ButtonPushedFcn', @(btn, event)generarFiltro());

    %--------------------------------------------------------------
    % Función anidada: genera el filtro y la ventana de resultados
    %--------------------------------------------------------------
    function generarFiltro()
        tipo  = filterType.Value;
        orden = orderField.Value;
        fs    = fsField.Value;
        frec  = str2num(cutoffField.Value); %#ok<ST2NM>
        modo  = outputMode.Value;
        
        % Validar las frecuencias de corte
        if any(frec <= 0) || any(frec >= fs/2)
            uialert(fig, ...
                'Las frecuencias de corte deben ser mayores a 0 y menores que fs/2.', ...
                'Error');
            return;
        end
        
        % Diseño DIGITAL Butterworth
        switch tipo
            case 'Pasa bajos'
                [b, a] = butter(orden, frec/(fs/2), 'low');
            case 'Pasa altos'
                [b, a] = butter(orden, frec/(fs/2), 'high');
            case 'Pasa banda'
                if numel(frec) ~= 2
                    uialert(fig, ...
                        'Debe ingresar dos frecuencias para un filtro pasa banda.', ...
                        'Error');
                    return;
                end
                [b, a] = butter(orden, frec/(fs/2), 'bandpass');
            case 'Elimina banda'
                if numel(frec) ~= 2
                    uialert(fig, ...
                        'Debe ingresar dos frecuencias para un filtro elimina banda.', ...
                        'Error');
                    return;
                end
                [b, a] = butter(orden, frec/(fs/2), 'stop');
        end
        
        if strcmp(modo, 'Herramienta MATLAB (fvtool)')
            fvtool(b,a);
            return;
        end

        %---------------- Ventana de resultados ----------------
        resultFig = uifigure('Name', 'Resultados del Filtro Butterworth', ...
                             'Position', [150 150 1200 680]);

        % Botón Guardar PNG (abajo derecha)
        uibutton(resultFig, 'Text', 'Guardar PNG', ...
            'Position', [1050 70 120 30], ...
            'ButtonPushedFcn', @(btn,event) guardarPNG(resultFig));

        % ===== Respuesta en frecuencia (digital) =====
        [H, f] = freqz(b, a, 1024, fs);

        % Izquierda: magnitud y fase
        ax1 = uiaxes(resultFig, 'Position', [40 390 540 220]);
        plot(ax1, f, 20*log10(abs(H)), 'LineWidth', 1.5);
        title(ax1, 'Magnitud (dB)');
        xlabel(ax1, 'Frecuencia (Hz)');
        ylabel(ax1, 'Magnitud (dB)');
        grid(ax1, 'on');
        % Asegurar al menos +10 dB para ver bien el rizado
        yl = ylim(ax1);
        if yl(2) < 10
            yl(2) = 10;
            ylim(ax1, yl);
        end
        
        ax2 = uiaxes(resultFig, 'Position', [40 130 540 220]);
        plot(ax2, f, angle(H)*180/pi, 'LineWidth', 1.5);
        title(ax2, 'Fase (grados)');
        xlabel(ax2, 'Frecuencia (Hz)');
        ylabel(ax2, 'Fase (°)');
        grid(ax2, 'on');
        
        % ===== Prototipo analógico Butterworth (LP) =====
        [z_lp, p_lp, k_lp] = buttap(orden);
        tituloProto = 'Prototipo Butterworth (LP)';
        [b_lp, a_lp] = zp2tf(z_lp, p_lp, k_lp);

        % ===== Filtro analógico resultante (LP/HP/BP/BS) =====
        Omega = 2*pi*frec;  % Hz -> rad/s

        switch tipo
            case 'Pasa bajos'
                [b_a, a_a] = lp2lp(b_lp, a_lp, Omega);
            case 'Pasa altos'
                [b_a, a_a] = lp2hp(b_lp, a_lp, Omega);
            case 'Pasa banda'
                if numel(Omega) ~= 2
                    uialert(fig,'Debe ingresar dos frecuencias.','Error');
                    return;
                end
                w0 = sqrt(Omega(1)*Omega(2));
                B  = Omega(2) - Omega(1);
                [b_a, a_a] = lp2bp(b_lp, a_lp, w0, B);
            case 'Elimina banda'
                if numel(Omega) ~= 2
                    uialert(fig,'Debe ingresar dos frecuencias.','Error');
                    return;
                end
                w0 = sqrt(Omega(1)*Omega(2));
                B  = Omega(2) - Omega(1);
                [b_a, a_a] = lp2bs(b_lp, a_lp, w0, B);
        end

        [z_a, p_a, k_a] = tf2zp(b_a, a_a);

        % ===== Derecha arriba: diagramas de polos y ceros =====
        % Diagrama 1: prototipo LP
        ax3 = uiaxes(resultFig, 'Position', [600 380 320 260]);
        plot(ax3, real(p_lp), imag(p_lp), 'x', 'LineWidth', 1.5, 'MarkerSize', 10);
        hold(ax3, 'on');
        if ~isempty(z_lp)
            plot(ax3, real(z_lp), imag(z_lp), 'o', ...
                 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor','none');
        end
        xline(ax3,0,'k:'); yline(ax3,0,'k:');
        grid(ax3,'on');
        title(ax3, {tituloProto; 'plano s'});
        xlabel(ax3,'\sigma'); ylabel(ax3,'j\omega');
        % límites simétricos y axis equal
        re_max_lp = 1.5*max([abs(real(p_lp)); abs(real(z_lp)); 1e-3]);
        im_max_lp = 1.5*max([abs(imag(p_lp)); abs(imag(z_lp)); 1e-3]);
        lim_lp = max(re_max_lp, im_max_lp);
        xlim(ax3,[-lim_lp lim_lp]);
        ylim(ax3,[-lim_lp lim_lp]);
        axis(ax3,'equal');

        % Diagrama 2: filtro analógico final
        ax4 = uiaxes(resultFig, 'Position', [880 380 320 260]);
        plot(ax4, real(p_a), imag(p_a), 'x', 'LineWidth', 1.5, 'MarkerSize', 10);
        hold(ax4,'on');
        if ~isempty(z_a)
            plot(ax4, real(z_a), imag(z_a), 'o', ...
                 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor','none');
        end
        xline(ax4,0,'k:'); yline(ax4,0,'k:');
        grid(ax4,'on');
        titFiltro = sprintf('Filtro analógico %s', tipo);
        title(ax4, {titFiltro; 'plano s'});
        xlabel(ax4,'\sigma'); ylabel(ax4,'j\omega');
        % rangos independientes
        re_max_a = 1.5*max([abs(real(p_a)); abs(real(z_a)); 1e-3]);
        if re_max_a < 0.5, re_max_a = 0.5; end
        xlim(ax4,[-re_max_a re_max_a]);
        im_max_a = 1.1*max([abs(imag(p_a)); abs(imag(z_a)); 1e-3]);
        ylim(ax4,[-im_max_a im_max_a]);

        % ===== H(s) del prototipo y H(s) real =====
        % Ajuste de tamaño de fuente según el orden máximo
        ordenProt = length(a_lp) - 1;
        ordenReal = length(a_a)  - 1;
        ordenMax  = max(ordenProt, ordenReal);
        if ordenMax <= 6
            fontSize = 18;
        elseif ordenMax <= 10
            fontSize = 16;
        else
            fontSize = 14;
        end

        HlatexProto = tf_s_to_latex(b_lp, a_lp, 'H_P');   % Prototipo
        HlatexReal  = tf_s_to_latex(b_a,  a_a,  'H_A');   % Analógico real

        % Eje para H_P(s)
        axHs1 = uiaxes(resultFig, 'Position', [40 70 1120 40]);
        axHs1.Visible = 'off';
        axis(axHs1,[0 1 0 1]);
        text(axHs1, 0.5, 0.5, HlatexProto, ...
             'Interpreter','latex', ...
             'HorizontalAlignment','center', ...
             'FontSize', fontSize);

        % Eje para H_A(s)
        axHs2 = uiaxes(resultFig, 'Position', [40 20 1120 40]);
        axHs2.Visible = 'off';
        axis(axHs2,[0 1 0 1]);
        text(axHs2, 0.5, 0.5, HlatexReal, ...
             'Interpreter','latex', ...
             'HorizontalAlignment','center', ...
             'FontSize', fontSize);


        % ===== Información numérica (coeficientes digitales) =====
        infoStr = sprintf(['Tipo de filtro: %s\n' ...
                           'Orden: %d\n' ...
                           'Frec. Corte: %s Hz\n' ...
                           'Fs: %d Hz\n\n' ...
                           'Coeficientes del Numerador digital (b):\n%s\n\n' ...
                           'Coeficientes del Denominador digital (a):\n%s'], ...
                          tipo, orden, mat2str(frec), fs, ...
                          mat2str(b), mat2str(a));
        uitextarea(resultFig, 'Position', [620 130 550 200], ...
                   'Value', infoStr, 'Editable', 'off', 'FontSize', 11);
    end
end


function Hlatex = tf_s_to_latex(b,a,varargin)
    % Construye H_x(s) = (num)/(den) en LaTeX, polinomios en s
    % name opcional: 'H', 'H_P', 'H_A', etc.
    if nargin < 3
        name = 'H';
    else
        name = varargin{1};
    end

    numStr = poly_to_latex_s(b);
    denStr = poly_to_latex_s(a);
    Hlatex = sprintf('$%s(s)=\\frac{%s}{%s}$', name, numStr, denStr);
end

function s = poly_to_latex_s(c)
    % c: vector de coeficientes en s, de grado n a 0 (como devuelve zp2tf)
    n = numel(c) - 1;
    parts = {};
    for k = 1:numel(c)
        coef = c(k);
        if abs(coef) < 1e-12, continue; end
        pow = n - (k - 1);   % exponente de s
        coefAbs = abs(coef);

        % signo
        if isempty(parts)
            if coef < 0, signStr = '-'; else, signStr = ''; end
        else
            if coef < 0, signStr = ' - '; else, signStr = ' + '; end
        end

        % === Construcción del término ===
        if pow == 0
            % Término independiente
            coefStr = formatCoeffLatex(coefAbs);
            term = sprintf('%s%s', signStr, coefStr);

        elseif pow == 1
            % Término en s
            if abs(coefAbs - 1) < 1e-12
                % Coeficiente ~1 -> solo "s"
                term = sprintf('%ss', signStr);
            else
                coefStr = formatCoeffLatex(coefAbs);
                term = sprintf('%s%s\\,s', signStr, coefStr);
            end

        else
            % Término en s^pow
            if abs(coefAbs - 1) < 1e-12
                term = sprintf('%ss^{%d}', signStr, pow);
            else
                coefStr = formatCoeffLatex(coefAbs);
                term = sprintf('%s%s\\,s^{%d}', signStr, coefStr, pow);
            end
        end

        parts{end+1} = term; %#ok<AGROW>
    end
    s = strjoin(parts,'');
end

function coeffStr = formatCoeffLatex(x)
    % Devuelve el coeficiente en formato LaTeX.
    % Ejemplos:
    %  1234      -> '1.23\times10^{3}'
    %  0.00567   -> '5.67\times10^{-3}'
    %  1.23      -> '1.23'

    numStr = sprintf('%.3g', x);   % notación compacta (puede llevar 'e')
    ePos = strfind(numStr, 'e');

    if isempty(ePos)
        % Sin exponente -> se deja tal cual
        coeffStr = numStr;
    else
        % Forma aeb -> a\times10^{b}
        mant = numStr(1:ePos-1);
        expStr = numStr(ePos+1:end);   % ej. '+04' o '-11'
        expVal = str2double(expStr);
        coeffStr = sprintf('%s\\times10^{%d}', mant, expVal);
    end
end


function guardarPNG(figHandle)
    [file, path] = uiputfile('figura.png', 'Guardar como PNG');
    if isequal(file,0)
        return;
    end
    filename = fullfile(path, file);

    % Aseguramos que la ventana está al frente y totalmente dibujada
    figure(figHandle);              % trae el uifigure al frente
    drawnow;                        % fuerza actualización gráfica

    try
        % Capturar la imagen de toda la ventana (tipo "screenshot")
        F = getframe(figHandle);
        imwrite(F.cdata, filename);
    catch ME
        warning('No se ha podido capturar la figura completa: %s', ME.message);
    end
end
