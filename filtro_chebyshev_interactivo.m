function filtro_chebyshev_interactivo(tipoChebyInicial)

    if nargin < 1
        tipoChebyInicial = 'Tipo I';   % valor por defecto
    end

    % Crear la ventana principal
    fig = uifigure('Name', 'Configurador de Filtro Chebyshev', ...
                   'Position', [100 100 450 560]);

    % Etiqueta del título
    uilabel(fig, 'Text', 'Configurador de Filtro Chebyshev', ...
            'Position', [50 510 350 40], 'FontSize', 16, ...
            'FontWeight', 'bold', 'HorizontalAlignment', 'center');

    % Tipo de filtro
    uilabel(fig, 'Text', 'Tipo de Filtro:', ...
            'Position', [50 460 120 30]);
    filterType = uidropdown(fig, ...
            'Position', [180 465 220 30], ...
            'Items', {'Pasa bajos', 'Pasa altos', ...
                      'Pasa banda', 'Elimina banda'});

    % Tipo de Chebyshev (I / II)
    uilabel(fig, 'Text', 'Tipo de Chebyshev:', ...
            'Position', [50 410 120 30]);
    chebyType = uidropdown(fig, ...
            'Position', [180 415 220 30], ...
            'Items', {'Tipo I', 'Tipo II'}, ...
            'Value', tipoChebyInicial);

    % Orden
    uilabel(fig, 'Text', 'Orden del Filtro:', ...
            'Position', [50 360 120 30]);
    orderField = uieditfield(fig, 'numeric', ...
            'Position', [180 365 220 30], ...
            'Limits', [1 Inf], 'Value', 4);

    % Frecuencia(s) de corte
    uilabel(fig, 'Text', 'Frecuencia(s) de Corte (Hz):', ...
            'Position', [50 310 200 30]);
    cutoffField = uieditfield(fig, 'text', ...
            'Position', [250 315 150 30], ...
            'Value', '1000');

    % Frecuencia de muestreo
    uilabel(fig, 'Text', 'Frecuencia de Muestreo (Hz):', ...
            'Position', [50 260 200 30]);
    fsField = uieditfield(fig, 'numeric', ...
            'Position', [250 265 150 30], ...
            'Limits', [1 Inf], 'Value', 8000);

    % Ondulación (dB)
    uilabel(fig, 'Text', 'Ondulación/Atenuación (dB):', ...
            'Position', [50 210 200 30]);

    rippleField = uieditfield(fig, 'numeric', ...
            'Position', [250 215 150 30], ...
            'Limits', [0 Inf], 'Value', 1);

    % Modo de visualización (igual que Butterworth)
    uilabel(fig, 'Text', 'Modo de Visualización:', ...
            'Position', [50 160 150 30]);
    outputMode = uidropdown(fig, ...
            'Position', [250 165 150 30], ...
            'Items', {'Ventana Independiente', ...
                      'Herramienta MATLAB (fvtool)'});

    % Botón para generar filtro
    uibutton(fig, 'Text', 'Generar Filtro', ...
             'Position', [100 90 250 40], ...
             'ButtonPushedFcn', @(btn, event)generarFiltro());

    % ==========================================================
    %   Función anidada: generar filtro y mostrar resultados
    % ==========================================================
    function generarFiltro()
        tipo   = filterType.Value;
        cheby  = chebyType.Value;
        orden  = orderField.Value;
        fs     = fsField.Value;
        frec   = str2num(cutoffField.Value); %#ok<ST2NM>
        ripple = rippleField.Value;
        modo   = outputMode.Value;

        % Validar frecuencias
        if any(frec <= 0) || any(frec >= fs/2)
            uialert(fig, ...
                'Las frecuencias de corte deben ser mayores a 0 y menores que fs/2.', ...
                'Error');
            return;
        end

        try
            % Diseño digital Chebyshev
            if strcmp(cheby, 'Tipo I')
                switch tipo
                    case 'Pasa bajos'
                        [b, a] = cheby1(orden, ripple, frec/(fs/2), 'low');
                    case 'Pasa altos'
                        [b, a] = cheby1(orden, ripple, frec/(fs/2), 'high');
                    case 'Pasa banda'
                        if numel(frec) ~= 2
                            uialert(fig, ...
                                'Debe ingresar dos frecuencias para un filtro pasa banda.', ...
                                'Error');
                            return;
                        end
                        [b, a] = cheby1(orden, ripple, frec/(fs/2), 'bandpass');
                    case 'Elimina banda'
                        if numel(frec) ~= 2
                            uialert(fig, ...
                                'Debe ingresar dos frecuencias para un filtro elimina banda.', ...
                                'Error');
                            return;
                        end
                        [b, a] = cheby1(orden, ripple, frec/(fs/2), 'stop');
                end
            else
                % Tipo II: ripple = atenuación mínima en banda de rechazo
                switch tipo
                    case 'Pasa bajos'
                        [b, a] = cheby2(orden, ripple, frec/(fs/2), 'low');
                    case 'Pasa altos'
                        [b, a] = cheby2(orden, ripple, frec/(fs/2), 'high');
                    case 'Pasa banda'
                        if numel(frec) ~= 2
                            uialert(fig, ...
                                'Debe ingresar dos frecuencias para un filtro pasa banda.', ...
                                'Error');
                            return;
                        end
                        [b, a] = cheby2(orden, ripple, frec/(fs/2), 'bandpass');
                    case 'Elimina banda'
                        if numel(frec) ~= 2
                            uialert(fig, ...
                                'Debe ingresar dos frecuencias para un filtro elimina banda.', ...
                                'Error');
                            return;
                        end
                        [b, a] = cheby2(orden, ripple, frec/(fs/2), 'stop');
                end
            end

            % === Modo fvtool, igual que en Butterworth ===
            if strcmp(modo, 'Herramienta MATLAB (fvtool)')
                fvtool(b, a);
                return;
            end

            %---------------- Ventana de resultados ----------------
            %---------------- Ventana de resultados ----------------
            resultFig = uifigure('Name', 'Resultados del Filtro Chebyshev', ...
                                 'Position', [150 150 1200 600]);

            % Botón Guardar PNG (abajo a la derecha)
            uibutton(resultFig, 'Text', 'Guardar PNG', ...
                'Position', [1050 10 120 30], ...
                'ButtonPushedFcn', @(btn,event) guardarPNG(resultFig));

            % ===== Respuesta en frecuencia (digital) =====
            [H, f] = freqz(b, a, 1024, fs);

            % --- PARTE IZQUIERDA: Magnitud y fase (más estrechas) ---
            % Magnitud
            ax1 = uiaxes(resultFig, 'Position', [40 340 540 220]);
            plot(ax1, f, 20*log10(abs(H)), 'LineWidth', 1.5);
            title(ax1, 'Magnitud (dB)');
            xlabel(ax1, 'Frecuencia (Hz)');
            ylabel(ax1, 'Magnitud (dB)');
            grid(ax1, 'on');

            % Fase
            ax2 = uiaxes(resultFig, 'Position', [40 80 540 220]);
            plot(ax2, f, angle(H)*180/pi, 'LineWidth', 1.5);
            title(ax2, 'Fase (grados)');
            xlabel(ax2, 'Frecuencia (Hz)');
            ylabel(ax2, 'Fase (°)');
            grid(ax2, 'on');

            % ===== PROTOTIPO ANALÓGICO CHEBYSHEV (LP) =====
            if strcmp(cheby, 'Tipo I')
                [z_lp, p_lp, k_lp] = cheb1ap(orden, ripple);
                tituloProto = 'Prototipo Chebyshev I (LP)';
            else
                [z_lp, p_lp, k_lp] = cheb2ap(orden, ripple);
                tituloProto = 'Prototipo Chebyshev II (LP)';
            end
            [b_lp, a_lp] = zp2tf(z_lp, p_lp, k_lp);

            % ===== FILTRO ANALÓGICO RESULTANTE (LP/HP/BP/BS) =====
            Omega = 2*pi*frec;   % Hz -> rad/s (solo para visualización)

            switch tipo
                case 'Pasa bajos'
                    [b_a, a_a] = lp2lp(b_lp, a_lp, Omega);
                case 'Pasa altos'
                    [b_a, a_a] = lp2hp(b_lp, a_lp, Omega);
                case 'Pasa banda'
                    if numel(Omega) ~= 2
                        uialert(fig, 'Debe ingresar dos frecuencias.', 'Error');
                        return;
                    end
                    w0 = sqrt(Omega(1)*Omega(2));   % frecuencia central
                    B  = Omega(2) - Omega(1);       % ancho de banda
                    [b_a, a_a] = lp2bp(b_lp, a_lp, w0, B);
                case 'Elimina banda'
                    if numel(Omega) ~= 2
                        uialert(fig, 'Debe ingresar dos frecuencias.', 'Error');
                        return;
                    end
                    w0 = sqrt(Omega(1)*Omega(2));
                    B  = Omega(2) - Omega(1);
                    [b_a, a_a] = lp2bs(b_lp, a_lp, w0, B);
            end

            [z_a, p_a, ~] = tf2zp(b_a, a_a);

            % --- PARTE DERECHA ARRIBA: Diagramas casi cuadrados ---
            % Diagrama 1: prototipo LP (más ancho)
            ax3 = uiaxes(resultFig, 'Position', [600 330 320 260]);
            plot(ax3, real(p_lp), imag(p_lp), 'x', 'LineWidth', 1.5, 'MarkerSize', 10);
            hold(ax3,'on');
            if ~isempty(z_lp)
                plot(ax3, real(z_lp), imag(z_lp), 'o', ...
                     'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor','none');
            end
            xline(ax3,0,'k:'); yline(ax3,0,'k:');
            grid(ax3,'on');
            title(ax3, {tituloProto; 'plano s'});
            xlabel(ax3,'\sigma'); ylabel(ax3,'j\omega');
            
            re_max_lp = 1.5*max([abs(real(p_lp)); abs(real(z_lp)); 1e-3]);
            im_max_lp = 1.5*max([abs(imag(p_lp)); abs(imag(z_lp)); 1e-3]);
            
            % Usar el mismo rango en σ y jω para que el diagrama no quede estrecho
            lim_lp = max(re_max_lp, im_max_lp);
            xlim(ax3,[-lim_lp lim_lp]);
            ylim(ax3,[-lim_lp lim_lp]);
            axis(ax3,'equal');

            
            % Diagrama 2: filtro analógico final (más ancho)
            ax4 = uiaxes(resultFig, 'Position', [880 330 320 260]);
            plot(ax4, real(p_a), imag(p_a), 'x', 'LineWidth', 1.5, 'MarkerSize', 10);
            hold(ax4,'on');
            if ~isempty(z_a)
                plot(ax4, real(z_a), imag(z_a), 'o', ...
                     'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor','none');
            end
            xline(ax4,0,'k:'); yline(ax4,0,'k:');
            grid(ax4,'on');
            title(ax4, {sprintf('Filtro analógico %s', tipo); 'plano s'});
            xlabel(ax4,'\sigma'); ylabel(ax4,'j\omega');
            
            % Rango horizontal: sólo en función de las partes reales
            re_max_a = 1.5*max([abs(real(p_a)); abs(real(z_a)); 1e-3]);
            % Aseguramos un mínimo para que no quede excesivamente estrecho
            if re_max_a < 0.5
                re_max_a = 0.5;
            end
            xlim(ax4, [-re_max_a, re_max_a]);
            
            % Rango vertical: sólo en función de las partes imaginarias
            im_max_a = 1.1*max([abs(imag(p_a)); abs(imag(z_a)); 1e-3]);
            ylim(ax4, [-im_max_a, im_max_a]);
            
            % Sin 'axis equal' para no comprimir el eje horizontal




            % ====== FUNCIÓN DE TRANSFERENCIA ANALÓGICA H(s) ======
            % usamos el prototipo LP, igual que en Butterworth
            [b_s, a_s] = zp2tf(z_lp, p_lp, k_lp);
            Hlatex = tf_s_to_latex(b_s, a_s);

            % Ajuste tamaño de letra según orden
            ordenProt = length(a_s) - 1;
            if ordenProt <= 6
                fontSize = 18;
            elseif ordenProt <= 10
                fontSize = 16;
            else
                fontSize = 14;
            end

            axHs = uiaxes(resultFig, 'Position', [40 10 1120 60]);
            axHs.Visible = 'off';
            axis(axHs,[0 1 0 1]);

            text(axHs, 0.5, 0.5, Hlatex, ...
                 'Interpreter','latex', ...
                 'HorizontalAlignment','center', ...
                 'FontSize', fontSize);

            % --- PARTE DERECHA ABAJO: Coeficientes ---
            infoStr = sprintf(['Tipo de filtro: %s\n' ...
                               'Tipo Chebyshev: %s\n' ...
                               'Orden: %d\n' ...
                               'Frec. Corte: %s Hz\n' ...
                               'Fs: %d Hz\n' ...
                               'Ondulación (dB): %.3g\n\n' ...
                               'Coeficientes del Numerador (b):\n%s\n\n' ...
                               'Coeficientes del Denominador (a):\n%s'], ...
                               tipo, cheby, orden, mat2str(frec), fs, ripple, ...
                               mat2str(b), mat2str(a));

            uitextarea(resultFig, 'Position', [620 80 550 200], ...
                       'Value', infoStr, 'Editable', 'off', 'FontSize', 11);


        catch ME
            uialert(fig, sprintf('Error al generar el filtro:\n%s', ME.message), ...
                    'Error');
        end
    end

end


% ==========================================================
%        Funciones auxiliares (mismas que Butterworth)
% ==========================================================
function Hlatex = tf_s_to_latex(b,a)
    % Construye H(s) = (num)/(den) en LaTeX, polinomios en s

    numStr = poly_to_latex_s(b);
    denStr = poly_to_latex_s(a);

    Hlatex = sprintf('$H(s)=\\frac{%s}{%s}$', numStr, denStr);
end

function s = poly_to_latex_s(c)
    % c: vector de coeficientes en s, de grado n a 0 (como devuelve zp2tf)
    n = numel(c) - 1;
    parts = {};

    for k = 1:numel(c)
        coef = c(k);
        if abs(coef) < 1e-12
            continue;
        end

        pow = n - (k - 1);   % exponente de s
        coefAbs = abs(coef);

        % signo
        if isempty(parts)
            if coef < 0
                signStr = '-';
            else
                signStr = '';
            end
        else
            if coef < 0
                signStr = ' - ';
            else
                signStr = ' + ';
            end
        end

        % término
        if pow == 0
            term = sprintf('%s%.3g', signStr, coefAbs);
        elseif pow == 1
            if abs(coefAbs - 1) < 1e-12
                term = sprintf('%ss', signStr);
            else
                term = sprintf('%s%.3g\\,s', signStr, coefAbs);
            end
        else
            if abs(coefAbs - 1) < 1e-12
                term = sprintf('%ss^{%d}', signStr, pow);
            else
                term = sprintf('%s%.3g\\,s^{%d}', signStr, coefAbs, pow);
            end
        end

        parts{end+1} = term; %#ok<AGROW>
    end

    s = strjoin(parts,'');
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
        warning('No se ha podido capturar la figura completa:', '%s', ME.message);
    end
end

