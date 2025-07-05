classdef app_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        ExitButton                      matlab.ui.control.Button
        EfectosPanel                    matlab.ui.container.Panel
        UmbralEditField                 matlab.ui.control.NumericEditField
        UmbralEditFieldLabel            matlab.ui.control.Label
        yEditField                      matlab.ui.control.NumericEditField
        yEditFieldLabel                 matlab.ui.control.Label
        cEditField                      matlab.ui.control.NumericEditField
        cEditFieldLabel                 matlab.ui.control.Label
        Bu_EditField                    matlab.ui.control.NumericEditField
        BEditFieldLabel                 matlab.ui.control.Label
        Au_EditField                    matlab.ui.control.NumericEditField
        AEditFieldLabel                 matlab.ui.control.Label
        Br_EditField                    matlab.ui.control.NumericEditField
        BEditFieldLabel_2               matlab.ui.control.Label
        Ar_EditField                    matlab.ui.control.NumericEditField
        AEditFieldLabel_2               matlab.ui.control.Label
        Efecto6ResaltarLabel            matlab.ui.control.Label
        Efecto5UmbralizacinLabel        matlab.ui.control.Label
        Efecto4PotenciasLabel           matlab.ui.control.Label
        Efecto3LogartmicoLabel          matlab.ui.control.Label
        Efecto2NegativodelaimagenLabel  matlab.ui.control.Label
        Efecto1UmbralizacinLabel        matlab.ui.control.Label
        CargarImagenyprocesarButton     matlab.ui.control.Button
        ResaltadoAxes                   matlab.ui.control.UIAxes
        UmbralDobleAxes                 matlab.ui.control.UIAxes
        PotenciaAxes                    matlab.ui.control.UIAxes
        LogAxes                         matlab.ui.control.UIAxes
        UmbralAxes                      matlab.ui.control.UIAxes
        NegativoAxes                    matlab.ui.control.UIAxes
        OriginalAxes                    matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: CargarImagenyprocesarButton
        function CargarImagenyprocesarButtonPushed(app, event)
            umbral = app.UmbralEditField.Value;
            c = app.cEditField.Value;
            y = app.yEditField.Value;
            A = app.Au_EditField.Value;
            B = app.Bu_EditField.Value;
            Ar = app.Ar_EditField.Value;
            Br = app.Br_EditField.Value;
        
            % cargar la imagen
            [filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp'}, 'Selecciona ka imagen');
            if isequal(filename, 0)
                return;
            end
            img = imread(fullfile(pathname, filename)); 
             
            %  Imagen  en escala de grises
            if size(img, 3) ~= 3
                uialert(app.UIFigure, ...
                    'La imagen está en escala de grises.', ...
                    'Imagen inválida', ...
                    'Icon', 'warning');
                return;
            end
            
            % Imagen RGB pero se ve gris
            R = img(:, :, 1);
            G = img(:, :, 2);
            B = img(:, :, 3);
            if isequal(R, G) && isequal(G, B)
                uialert(app.UIFigure, ... 
                    'Imagen es RGB pero se visualiza en escala de grises.', ...
                    'Imagen inválida', ...
                    'Icon', 'warning');
                return;
            end


            % imagen original
            imshow(img, 'Parent', app.OriginalAxes);
            
            % convertimos a escala de grises
            gray = rgb2gray(img);
            gray = im2double(gray);

            %% efecto 1 
            umbral_norm = umbral / 255; % si es mayor, entonces es 0
            efecto1 = gray >= umbral_norm;
            imshow(efecto1, 'Parent', app.UmbralAxes);
        
            %%E Efecto 2
            efecto2 = 1 - gray; % negativo
            imshow(efecto2, 'Parent', app.NegativoAxes);
        
            %% efecto 3 
            efecto3 = log(1 + gray); %c log(1+r), asumimos c=1 porque no hay un text
            efecto3 = mat2gray(efecto3);
            imshow(efecto3, 'Parent', app.LogAxes);
        
            %% efecto 4 
            efecto4 = c * (gray .^ y); %% c r^gamma
            efecto4 = mat2gray(efecto4);
            imshow(efecto4, 'Parent', app.PotenciaAxes);
        
            %% efecto 5  
            A_norm = A / 255;
            B_norm = B / 255;
            efecto5 = (gray >= A_norm) & (gray <= B_norm); % rango de A y B normalizado
            imshow(efecto5, 'Parent', app.UmbralDobleAxes);
        
            %% Efecto 6  
            Ar_norm = Ar / 255;
            Br_norm = Br / 255;
            mascara_resaltado = (gray >= Ar_norm) & (gray <= Br_norm);
            efecto6 = zeros(size(gray));
            efecto6(mascara_resaltado) = gray(mascara_resaltado);
            imshow(efecto6, 'Parent', app.ResaltadoAxes); 

        end

        % Button pushed function: ExitButton
        function ExitButtonPushed(app, event)
            close(app.UIFigure);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [1 1 1];
            app.UIFigure.Position = [100 100 923 642];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.Resize = 'off';
            app.UIFigure.Theme = 'light';

            % Create OriginalAxes
            app.OriginalAxes = uiaxes(app.UIFigure);
            title(app.OriginalAxes, 'Original')
            xlabel(app.OriginalAxes, 'X')
            ylabel(app.OriginalAxes, 'Y')
            zlabel(app.OriginalAxes, 'Z')
            app.OriginalAxes.Position = [624 441 289 185];

            % Create NegativoAxes
            app.NegativoAxes = uiaxes(app.UIFigure);
            title(app.NegativoAxes, 'Efecto 2')
            xlabel(app.NegativoAxes, 'X')
            ylabel(app.NegativoAxes, 'Y')
            zlabel(app.NegativoAxes, 'Z')
            app.NegativoAxes.Position = [318 237 289 185];

            % Create UmbralAxes
            app.UmbralAxes = uiaxes(app.UIFigure);
            title(app.UmbralAxes, 'Efecto 1')
            xlabel(app.UmbralAxes, 'X')
            ylabel(app.UmbralAxes, 'Y')
            zlabel(app.UmbralAxes, 'Z')
            app.UmbralAxes.Position = [12 237 289 185];

            % Create LogAxes
            app.LogAxes = uiaxes(app.UIFigure);
            title(app.LogAxes, 'Efecto 3')
            xlabel(app.LogAxes, 'X')
            ylabel(app.LogAxes, 'Y')
            zlabel(app.LogAxes, 'Z')
            app.LogAxes.Position = [624 237 289 185];

            % Create PotenciaAxes
            app.PotenciaAxes = uiaxes(app.UIFigure);
            title(app.PotenciaAxes, 'Efecto 5')
            xlabel(app.PotenciaAxes, 'X')
            ylabel(app.PotenciaAxes, 'Y')
            zlabel(app.PotenciaAxes, 'Z')
            app.PotenciaAxes.Position = [318 34 289 185];

            % Create UmbralDobleAxes
            app.UmbralDobleAxes = uiaxes(app.UIFigure);
            title(app.UmbralDobleAxes, 'Efecto 4')
            xlabel(app.UmbralDobleAxes, 'X')
            ylabel(app.UmbralDobleAxes, 'Y')
            zlabel(app.UmbralDobleAxes, 'Z')
            app.UmbralDobleAxes.Position = [12 35 289 185];

            % Create ResaltadoAxes
            app.ResaltadoAxes = uiaxes(app.UIFigure);
            title(app.ResaltadoAxes, 'Efecto 6')
            xlabel(app.ResaltadoAxes, 'X')
            ylabel(app.ResaltadoAxes, 'Y')
            zlabel(app.ResaltadoAxes, 'Z')
            app.ResaltadoAxes.Position = [624 34 289 185];

            % Create EfectosPanel
            app.EfectosPanel = uipanel(app.UIFigure);
            app.EfectosPanel.Title = 'Efectos';
            app.EfectosPanel.Position = [1 432 605 211];

            % Create CargarImagenyprocesarButton
            app.CargarImagenyprocesarButton = uibutton(app.EfectosPanel, 'push');
            app.CargarImagenyprocesarButton.ButtonPushedFcn = createCallbackFcn(app, @CargarImagenyprocesarButtonPushed, true);
            app.CargarImagenyprocesarButton.Position = [438 18 154 22];
            app.CargarImagenyprocesarButton.Text = 'Cargar Imagen y procesar';

            % Create Efecto1UmbralizacinLabel
            app.Efecto1UmbralizacinLabel = uilabel(app.EfectosPanel);
            app.Efecto1UmbralizacinLabel.Position = [20 160 128 22];
            app.Efecto1UmbralizacinLabel.Text = 'Efecto1: Umbralización';

            % Create Efecto2NegativodelaimagenLabel
            app.Efecto2NegativodelaimagenLabel = uilabel(app.EfectosPanel);
            app.Efecto2NegativodelaimagenLabel.Position = [20 129 172 22];
            app.Efecto2NegativodelaimagenLabel.Text = 'Efecto2: Negativo de la imagen';

            % Create Efecto3LogartmicoLabel
            app.Efecto3LogartmicoLabel = uilabel(app.EfectosPanel);
            app.Efecto3LogartmicoLabel.Position = [20 99 115 22];
            app.Efecto3LogartmicoLabel.Text = 'Efecto3: Logarítmico';

            % Create Efecto4PotenciasLabel
            app.Efecto4PotenciasLabel = uilabel(app.EfectosPanel);
            app.Efecto4PotenciasLabel.Position = [20 69 105 22];
            app.Efecto4PotenciasLabel.Text = 'Efecto4: Potencias';

            % Create Efecto5UmbralizacinLabel
            app.Efecto5UmbralizacinLabel = uilabel(app.EfectosPanel);
            app.Efecto5UmbralizacinLabel.Position = [20 39 128 22];
            app.Efecto5UmbralizacinLabel.Text = 'Efecto5: Umbralización';

            % Create Efecto6ResaltarLabel
            app.Efecto6ResaltarLabel = uilabel(app.EfectosPanel);
            app.Efecto6ResaltarLabel.Position = [20 9 97 22];
            app.Efecto6ResaltarLabel.Text = 'Efecto6: Resaltar';

            % Create AEditFieldLabel_2
            app.AEditFieldLabel_2 = uilabel(app.EfectosPanel);
            app.AEditFieldLabel_2.HorizontalAlignment = 'right';
            app.AEditFieldLabel_2.Position = [181 9 25 22];
            app.AEditFieldLabel_2.Text = 'A';

            % Create Ar_EditField
            app.Ar_EditField = uieditfield(app.EfectosPanel, 'numeric');
            app.Ar_EditField.Position = [221 9 41 22];
            app.Ar_EditField.Value = 50;

            % Create BEditFieldLabel_2
            app.BEditFieldLabel_2 = uilabel(app.EfectosPanel);
            app.BEditFieldLabel_2.HorizontalAlignment = 'right';
            app.BEditFieldLabel_2.Position = [273 9 25 22];
            app.BEditFieldLabel_2.Text = 'B';

            % Create Br_EditField
            app.Br_EditField = uieditfield(app.EfectosPanel, 'numeric');
            app.Br_EditField.Position = [313 9 39 22];
            app.Br_EditField.Value = 120;

            % Create AEditFieldLabel
            app.AEditFieldLabel = uilabel(app.EfectosPanel);
            app.AEditFieldLabel.HorizontalAlignment = 'right';
            app.AEditFieldLabel.Position = [181 40 25 22];
            app.AEditFieldLabel.Text = 'A';

            % Create Au_EditField
            app.Au_EditField = uieditfield(app.EfectosPanel, 'numeric');
            app.Au_EditField.Position = [221 40 41 22];
            app.Au_EditField.Value = 50;

            % Create BEditFieldLabel
            app.BEditFieldLabel = uilabel(app.EfectosPanel);
            app.BEditFieldLabel.HorizontalAlignment = 'right';
            app.BEditFieldLabel.Position = [273 40 25 22];
            app.BEditFieldLabel.Text = 'B';

            % Create Bu_EditField
            app.Bu_EditField = uieditfield(app.EfectosPanel, 'numeric');
            app.Bu_EditField.Position = [313 40 39 22];
            app.Bu_EditField.Value = 120;

            % Create cEditFieldLabel
            app.cEditFieldLabel = uilabel(app.EfectosPanel);
            app.cEditFieldLabel.HorizontalAlignment = 'right';
            app.cEditFieldLabel.Position = [181 69 25 22];
            app.cEditFieldLabel.Text = 'c';

            % Create cEditField
            app.cEditField = uieditfield(app.EfectosPanel, 'numeric');
            app.cEditField.Position = [221 69 41 22];
            app.cEditField.Value = 1.1;

            % Create yEditFieldLabel
            app.yEditFieldLabel = uilabel(app.EfectosPanel);
            app.yEditFieldLabel.HorizontalAlignment = 'right';
            app.yEditFieldLabel.Position = [273 69 25 22];
            app.yEditFieldLabel.Text = 'y';

            % Create yEditField
            app.yEditField = uieditfield(app.EfectosPanel, 'numeric');
            app.yEditField.Position = [313 69 39 22];
            app.yEditField.Value = 0.1;

            % Create UmbralEditFieldLabel
            app.UmbralEditFieldLabel = uilabel(app.EfectosPanel);
            app.UmbralEditFieldLabel.HorizontalAlignment = 'right';
            app.UmbralEditFieldLabel.Position = [205 162 44 22];
            app.UmbralEditFieldLabel.Text = 'Umbral';

            % Create UmbralEditField
            app.UmbralEditField = uieditfield(app.EfectosPanel, 'numeric');
            app.UmbralEditField.Position = [264 162 61 22];
            app.UmbralEditField.Value = 50;

            % Create ExitButton
            app.ExitButton = uibutton(app.UIFigure, 'push');
            app.ExitButton.ButtonPushedFcn = createCallbackFcn(app, @ExitButtonPushed, true);
            app.ExitButton.Position = [881 613 42 30];
            app.ExitButton.Text = 'Exit';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end