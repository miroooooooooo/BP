function [pocet_vyjdenych_bodov, ostalo_na_mape, step, dostal_sa_do_ciela] = simulate_run(nn, mapNum, sensorMode, pocetLucov, geneIndex, popIndex, show_progress, plot_results)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    % simulate_run(nn, 4, sensorMode, pocet_lucov, nn.bestIndex, 1, 1)
    if exist('pocetLucov', 'var') == 0
        pocetLucov = 7;
    end
    if exist('geneIndex', 'var') == 0
        geneIndex = nn.bestIndex;
    end
    if exist('show_progress', 'var') == 0
        show_progress = 1;
    end
    if exist('plot_results', 'var') == 0
        plot_results = 1;
    end
    if exist('popIndex', 'var') == 0
        popIndex = 1; % index populacie, ktoru chceme otestovat
    end
%     figure('Position', [100, 100, 800, 500]);
    if show_progress || plot_results
        figure('WindowState', 'maximized');
    end
    testMap = Map(mapNum);
    step = 0;
    % sensorMode = 3; % % výber módu senzoru 1 -> radar, 2 -> kamera, 3 -> fúzia
    
    testNN = nn; % Načítanie NS z aktuálneho trénovania
    [testNN, weights] = testNN.convertWeights(popIndex, geneIndex); 
    
    car = Car(testMap.startX, testMap.startY, testMap.startAngle, testMap, sensorMode);
    % Simulácia vykreslenia
    speeds = zeros(testMap.maxSteps, 1);
    % moje
    outs_plyn = zeros(testMap.maxSteps, 1);
    natocenia = zeros(testMap.maxSteps, 1);
    
    na_mape = zeros(testMap.maxSteps, 1);
    trafilo_stenu = zeros(testMap.maxSteps, 1);

    xs = zeros(testMap.maxSteps, 1);
    ys = zeros(testMap.maxSteps, 1);

    if show_progress
        show(car.map)
        hold on;
        car.mapObject.drawCheckpoints();
        car.mapObject.drawFinish();
    end


    while ~testMap.checkFinish(car.carPosition) && step < testMap.maxSteps
        step = step + 1;

        [sensorReadings, ~] = car.getSensorReadings();
        if ~car.checkInsidePosition([car.carPosition  car.headingAngle])
            break;
        end
        [out] = testNN.evaluateOutput([sensorReadings, car.speed / car.multiplyParameters], [pi/4], weights, popIndex, geneIndex); % get output angle
        car = car.update(out(1), out(2));

        if show_progress
            car.drawCar(sensorMode);
            pause(0.0001);
        end

        xs(step) = car.carPosition(1);
        ys(step) = car.carPosition(2);
        speeds(step) = car.speed / car.multiplyParameters;

        outs_plyn(step) = out(2);
        natocenia(step) = out(1);
        na_mape(step) = car.checkInsidePosition([car.carPosition, car.headingAngle]);
        trafilo_stenu(step) = car.getCarOccupancy(show_progress);
        if trafilo_stenu(step) >= 6
            break;
        end
    end

    dostal_sa_do_ciela = testMap.checkFinish(car.carPosition);

    if plot_results
        car.drawCar(sensorMode);
        hold on
        plot(xs(:), ys(:), 'X', 'Color', '#80c3ff');
        set(gca, 'Ydir', 'reverse')
    end

    if plot_results
        sprintf('Počet krokov: %d', step)
    end
    if sum(na_mape) >= step && trafilo_stenu(step) < 6 
        ostalo_na_mape = true;
        if plot_results
            sprintf('Auto sa udržalo na mape')
        end
    else
        ostalo_na_mape = false;
        if plot_results
            sprintf('Auto vyšlo z mapy')
        end
    end
    pocet_vyjdenych_bodov = sum(trafilo_stenu);
    if plot_results
        sprintf('Počet vyjdení z trate: %d', pocet_vyjdenych_bodov)
    end

    if plot_results
        % uz iba grafy
        figure;
        tiledlayout(2,1);
        nexttile;
        plot(speeds(1:step));
        ylim([-6, 21])
        hold on;
        yyaxis right;
        plot(outs_plyn(1:step));
        ylim([-1.25, 1.25])
        title('rychlost + plyn + natocenia');
        % natocenie: + znamena doprava, - znamena dolava
        plot(natocenia(1:step), '-g');
        yline(0, 'r--');
        legend('rychlost', 'plyn', 'natocenia', '0', 'Location', 'southeast');
    
        nexttile;
        plot(~na_mape(1:step));
        hold on;
        plot(trafilo_stenu(1:step));
        title('zlyhania');
        legend('mimo mapy', 'trafilo stenu');
        ylim([-0.25, 6.25]);
    end
end