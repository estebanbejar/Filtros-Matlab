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

    % Ondulación / Atenuación (dB)
    uilabel(fig, 'Text', 'Ondulación/Atenuación* (dB):', ...
            'Position', [50 210 200 30]);

    rippleField = uieditfield(fig, 'numeric', ...
            'Position', [250 215 150 30], ...
            'Limits', [0 Inf], 'Value', 1);

    % Modo de visualización
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

    uilabel(fig, 'Text', '* Tipo I: Ondulación sugerida < 3 dB', ...
            'Position', [75 50 400 30],'FontAngle', 'italic');
    uilabel(fig, 'Text', '*Tipo II: Atenuación sugerida > 40 dB', ...
            'Position', [75 30 400 30],'FontAngle', 'italic');

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

            % === Modo fvtool ===
            if strcmp(modo, 'Herramienta MATLAB (fvtool)')
                fvtool(b, a);
                return;
            end

            %---------------- Ventana de resultados ----------------
            resultFig = uifigure('Name', 'Resultados del Filtro Chebyshev', ...
                                 'Position', [150 150 1200 640]); % más alta

            % Botón Guardar PNG (abajo izquierda, centrado con el Bode)
            uibutton(resultFig, 'Text', 'Guardar PNG', ...
                'Position', [250 30 120 30], ...
                'ButtonPushedFcn', @(btn,event) guardarPNG(resultFig));

            % ===== Respuesta en frecuencia (digital) =====
            [H, f] = freqz(b, a, 1024, fs);

            % --- PARTE IZQUIERDA: Magnitud y fase ---
            ax1 = uiaxes(resultFig, 'Position', [40 360 540 220]);
            plot(ax1, f, 20*log10(abs(H)), 'LineWidth', 1.5);
            title(ax1, 'Magnitud (dB)');
            xlabel(ax1, 'Frecuencia (Hz)');
            ylabel(ax1, 'Magnitud (dB)');
            grid(ax1, 'on');
            % Asegurar al menos +10 dB y limitar el mínimo visible a -150 dB
            yl = ylim(ax1);
            if yl(1) < -150
                yl(1) = -150;
            end
            if yl(2) < 10
                yl(2) = 10;
            end
            ylim(ax1, yl);

            ax2 = uiaxes(resultFig, 'Position', [40 110 540 220]);
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
            Omega = 2*pi*frec;   % Hz -> rad/s

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

            % --- PARTE DERECHA ARRIBA: Diagramas de polos y ceros ---
            % Prototipo LP
            ax3 = uiaxes(resultFig, 'Position', [600 350 320 260]);
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
            lim_lp = max(re_max_lp, im_max_lp);
            xlim(ax3,[-lim_lp lim_lp]);
            ylim(ax3,[-lim_lp lim_lp]);
            axis(ax3,'equal');

            % Filtro analógico real
            ax4 = uiaxes(resultFig, 'Position', [880 350 320 260]);
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

            re_max_a = 1.5*max([abs(real(p_a)); abs(real(z_a)); 1e-3]);
            if re_max_a < 0.5, re_max_a = 0.5; end
            xlim(ax4, [-re_max_a, re_max_a]);

            im_max_a = 1.1*max([abs(imag(p_a)); abs(imag(z_a)); 1e-3]);
            ylim(ax4, [-im_max_a, im_max_a]);

    % ===== FUNCIONES DE TRANSFERENCIA =====
        % H_P(s): prototipo analógico normalizado
        % H_A(s): filtro analógico transformado
        % H_D(z): filtro digital implementable
        ordenMax = max([length(a_lp)-1, length(a_a)-1, length(a)-1]);
        if ordenMax <= 6
            fontSize = 13;
        elseif ordenMax <= 10
            fontSize = 11;
        else
            fontSize = 9;
        end

        HlatexProto = tf_s_to_latex(b_lp, a_lp, 'H_P');
        HlatexReal  = tf_s_to_latex(b_a,  a_a,  'H_A');
        HlatexDig   = tf_z_to_latex(b,    a,    'H_D');
        exprHeader  = sprintf('Filtro Chebyshev %s, %s. Orden: %d. Frec. corte: %s Hz. Fs: %g Hz. Ondulación/Atenuación: %.3g dB.', ...
                              cheby, tipo, orden, mat2str(frec), fs, ripple);

        % Eje para H_P(s) en la zona inferior derecha
        axHs1 = uiaxes(resultFig, 'Position', [610 270 570 55]);
        axHs1.Visible = 'off';
        axis(axHs1,[0 1 0 1]);
        text(axHs1, 0.5, 0.5, HlatexProto, ...
             'Interpreter','latex', ...
             'HorizontalAlignment','center', ...
             'FontSize', fontSize);

        % Eje para H_A(s) en la zona inferior derecha
        axHs2 = uiaxes(resultFig, 'Position', [610 180 570 55]);
        axHs2.Visible = 'off';
        axis(axHs2,[0 1 0 1]);
        text(axHs2, 0.5, 0.5, HlatexReal, ...
             'Interpreter','latex', ...
             'HorizontalAlignment','center', ...
             'FontSize', fontSize);

        % Eje para H_D(z) en la zona inferior derecha
        axHz = uiaxes(resultFig, 'Position', [610 90 570 55]);
        axHz.Visible = 'off';
        axis(axHz,[0 1 0 1]);
        text(axHz, 0.5, 0.5, HlatexDig, ...
             'Interpreter','latex', ...
             'HorizontalAlignment','center', ...
             'FontSize', fontSize);

        % Botones para exportar las expresiones matemáticas
        uibutton(resultFig, 'Text', 'Guardar .md', ...
            'Position', [720 30 120 30], ...
            'ButtonPushedFcn', @(btn,event) guardarExpresionesMD(exprHeader, HlatexProto, HlatexReal, HlatexDig));

        uibutton(resultFig, 'Text', 'Guardar LaTeX', ...
            'Position', [880 30 120 30], ...
            'ButtonPushedFcn', @(btn,event) guardarExpresionesTXT(exprHeader, HlatexProto, HlatexReal, HlatexDig));

        catch ME
            uialert(fig, sprintf('Error al generar el filtro:\n%s', ME.message), ...
                    'Error');
        end
    end
end

% ==========================================================
%        Funciones auxiliares (compartidas)
% ==========================================================
function Hlatex = tf_s_to_latex(b,a,varargin)
    % Construye H_x(s) = num/den en LaTeX
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
    % c: vector de coeficientes en s, de grado n a 0
    n = numel(c) - 1;
    parts = {};
    for k = 1:numel(c)
        coef = c(k);
        if abs(coef) < 1e-12, continue; end
        pow = n - (k - 1);
        coefAbs = abs(coef);

        % signo
        if isempty(parts)
            if coef < 0, signStr = '-'; else, signStr = ''; end
        else
            if coef < 0, signStr = ' - '; else, signStr = ' + '; end
        end

        % término
        if pow == 0
            coefStr = formatCoeffLatex(coefAbs);
            term = sprintf('%s%s', signStr, coefStr);
        elseif pow == 1
            if abs(coefAbs - 1) < 1e-12
                term = sprintf('%ss', signStr);
            else
                coefStr = formatCoeffLatex(coefAbs);
                term = sprintf('%s%s\\,s', signStr, coefStr);
            end
        else
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
    % Devuelve el coeficiente en formato LaTeX:
    % 1.64e+04 -> '1.64\times10^{4}'
    numStr = sprintf('%.3g', x);
    ePos = strfind(numStr, 'e');
    if isempty(ePos)
        coeffStr = numStr;
    else
        mant = numStr(1:ePos-1);
        expStr = numStr(ePos+1:end);   % +04, -11, etc.
        expVal = str2double(expStr);
        coeffStr = sprintf('%s\\times10^{%d}', mant, expVal);
    end
end


function Hlatex = tf_z_to_latex(b,a,varargin)
    % Construye H_D(z) = num/den en LaTeX usando potencias z^{-1}
    if nargin < 3
        name = 'H_D';
    else
        name = varargin{1};
    end

    numStr = poly_to_latex_zminus(b);
    denStr = poly_to_latex_zminus(a);
    Hlatex = sprintf('$%s(z)=\\frac{%s}{%s}$', name, numStr, denStr);
end

function s = poly_to_latex_zminus(c)
    % c: vector de coeficientes digitales:
    % c(1) + c(2) z^{-1} + c(3) z^{-2} + ...
    parts = {};

    for k = 1:numel(c)
        coef = c(k);
        if abs(coef) < 1e-12, continue; end

        pow = k - 1;      % exponente negativo de z
        coefAbs = abs(coef);

        % signo
        if isempty(parts)
            if coef < 0, signStr = '-'; else, signStr = ''; end
        else
            if coef < 0, signStr = ' - '; else, signStr = ' + '; end
        end

        % término
        if pow == 0
            coefStr = formatCoeffLatex(coefAbs);
            term = sprintf('%s%s', signStr, coefStr);
        elseif pow == 1
            if abs(coefAbs - 1) < 1e-12
                term = sprintf('%sz^{-1}', signStr);
            else
                coefStr = formatCoeffLatex(coefAbs);
                term = sprintf('%s%s\\,z^{-1}', signStr, coefStr);
            end
        else
            if abs(coefAbs - 1) < 1e-12
                term = sprintf('%sz^{-%d}', signStr, pow);
            else
                coefStr = formatCoeffLatex(coefAbs);
                term = sprintf('%s%s\\,z^{-%d}', signStr, coefStr, pow);
            end
        end

        parts{end+1} = term; %#ok<AGROW>
    end

    s = strjoin(parts,'');
end


function guardarExpresionesMD(exprHeader, HlatexProto, HlatexReal, HlatexDig)
    [file, path] = uiputfile('funciones_transferencia.md', 'Guardar expresiones como Markdown');
    if isequal(file,0)
        return;
    end
    filename = fullfile(path, file);

    fid = fopen(filename, 'w', 'n', 'UTF-8');
    if fid == -1
        warning('No se ha podido crear el archivo Markdown.');
        return;
    end

    fprintf(fid, '# Funciones de transferencia\n\n');
    fprintf(fid, '%s\n\n', exprHeader);
    fprintf(fid, '## Prototipo analógico normalizado\n\n%s\n\n', HlatexProto);
    fprintf(fid, '## Filtro analógico transformado\n\n%s\n\n', HlatexReal);
    fprintf(fid, '## Filtro digital\n\n%s\n\n', HlatexDig);
    fprintf(fid, '---\n\n');
    fprintf(fid, 'La función \\(H_P(s)\\) corresponde al prototipo analógico normalizado.\n\n');
    fprintf(fid, 'La función \\(H_A(s)\\) corresponde al filtro analógico después de la transformación de frecuencia.\n\n');
    fprintf(fid, 'La función \\(H_D(z)\\) corresponde al filtro digital implementable.\n');
    fclose(fid);
end

function guardarExpresionesTXT(exprHeader, HlatexProto, HlatexReal, HlatexDig)
    [file, path] = uiputfile('funciones_transferencia_latex.txt', 'Guardar código LaTeX');
    if isequal(file,0)
        return;
    end
    filename = fullfile(path, file);

    fid = fopen(filename, 'w', 'n', 'UTF-8');
    if fid == -1
        warning('No se ha podido crear el archivo de texto.');
        return;
    end

    fprintf(fid, 'Funciones de transferencia\n');
    fprintf(fid, '%s\n\n', exprHeader);
    fprintf(fid, 'H_P(s):\n%s\n\n', HlatexProto);
    fprintf(fid, 'H_A(s):\n%s\n\n', HlatexReal);
    fprintf(fid, 'H_D(z):\n%s\n', HlatexDig);
    fclose(fid);
end

function guardarPNG(figHandle)
    [file, path] = uiputfile('figura.png', 'Guardar como PNG');
    if isequal(file,0)
        return;
    end
    filename = fullfile(path, file);

    figure(figHandle);
    drawnow;
    try
        F = getframe(figHandle);
        imwrite(F.cdata, filename);
    catch ME
        warning('No se ha podido capturar la figura completa: %s', ME.message);
    end
end
