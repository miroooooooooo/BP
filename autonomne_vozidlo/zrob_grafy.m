close all; clear; clc;

algoritmy = {"GA_jednoduchy", "GA_ostrovny2", "DE", "PSO"};
% algoritmy = {"GA_obycajny", "GA_ostrovny", "DE", "PSO"};
struktury_ns = {"8_6_6_2", "8_10_10_2", "8_15_15_2"};

pocet_zbehnuti = 10;
pocet_lucov = 7;

ff_test = @fitness_custom_testovacia;
tic
for algo=1:length(algoritmy)
    for s=1:length(struktury_ns)
        figure("Name", strcat(algoritmy{algo}, "___", struktury_ns{s}));
%         tiledlayout(4,2);
        tiledlayout(2,2);

        fit_values = zeros(1,pocet_zbehnuti);

        for run=1:pocet_zbehnuti
            filename = strcat(algoritmy{algo}, "___", struktury_ns{s}, "___", num2str(run), ".mat");
            load(filename);

            % vyvoj fitness
            nexttile(1);
            hold on;
            plot(1:gens, nn.fitTrend.pop1(1:length(1:gens)), "DisplayName", strcat("Spustenie č. ", num2str(run)));
            xlabel("generácia")
            ylabel("hodnota účelovej funkcie")
            legend("show")
            set(gca, "fontsize", 14)

            % "zoom" na fitness
            nexttile(2);
            hold on;
            plot(1:gens, nn.fitTrend.pop1(1:length(1:gens)), "DisplayName", strcat("Spustenie č. ", num2str(run)));
            xlabel("generácia")
            ylabel("hodnota účelovej funkcie")
            legend("show")
            ylim([-6000, -5850])
            xlim([100, gens])
            set(gca, "fontsize", 14)

            if algoritmy{algo} == "PSO"
                pop_num = 2;
            else
                pop_num = 1;
            end

            % testovacie mapy
            [pocet_vyjdenych_bodov_mapa4, ostalo_na_mape4, pocet_krokov_mapa4, v_cieli_mapa4] = simulate_run(nn, 4, sensorMode, pocet_lucov, nn.bestIndex, pop_num, 0, 0);
            [pocet_vyjdenych_bodov_mapa6, ostalo_na_mape6, pocet_krokov_mapa6, v_cieli_mapa6] = simulate_run(nn, 6, sensorMode, pocet_lucov, nn.bestIndex, pop_num, 0, 0);

            % vypocitaj fitness pre testovacie mapy
            map4 = Map(4);
            map6 = Map(6);
            car4 = Car(map4.startX, map4.startY, map4.startAngle, map4, sensorMode);
            car6 = Car(map6.startX, map6.startY, map6.startAngle, map6, sensorMode);
            test_fitness = ff_test(nn, map4, car4, pop_num, nn.bestIndex) + ff_test(nn, map6, car6, pop_num, nn.bestIndex);
            
            if v_cieli_mapa4 && v_cieli_mapa6 
                bar_color = 'g';
            else
                if ostalo_na_mape4 || ostalo_na_mape6
                    bar_color = 'y';
                end
                if ~ostalo_na_mape4 || ~ostalo_na_mape6
                    bar_color = 'r';
                end
            end

            % hodnota fitness pre testovacie mapy
            nexttile(3);
            hold on;
            bar(categorical(run), test_fitness, bar_color);
            xlabel("Poradie spustenia")
            ylabel("hodnota účelovej funkcie pre testovacie mapy")
            set(gca, "fontsize", 14)

            % zoom na fitness
            nexttile(4)
            hold on;
            bar(categorical(run), test_fitness, bar_color);
            ylim([-4000, 750]);
            xlabel("Poradie spustenia")
            ylabel("hodnota účelovej funkcie pre testovacie mapy")
            set(gca, "fontsize", 14)

            final_fitness = test_fitness;
            fit_values(run) = final_fitness;
            fprintf("%s %s, run no. %d, fitness: %f\n", algoritmy{algo}, struktury_ns{s}, run, final_fitness)
        end

        nexttile(3)
        hold on;
        h = zeros(3,1);
        h(1) = plot(NaN, NaN, 'g');
        h(2) = plot(NaN, NaN, 'y');
        h(3) = plot(NaN, NaN, 'r');
        legend(h, 'Vozidlo dosiahlo oba ciele', 'Vozidlo sa nedostalo do oboch cieľov', 'Vozidlo vyšlo z trate/mapy')

        nexttile(4)
        h = zeros(3,1);
        h(1) = plot(NaN, NaN, 'g');
        h(2) = plot(NaN, NaN, 'y');
        h(3) = plot(NaN, NaN, 'r');
        legend(h, 'Vozidlo dosiahlo oba ciele', 'Vozidlo sa nedostalo do oboch cieľov', 'Vozidlo vyšlo z trate/mapy')

        % vypis min, mean, max fitness pre dany algoritmus a strukturu NS
        fprintf("\n%s %s, min fit: %f, mean fit: %f, max fit: %f\n\n\n\n", algoritmy{algo}, struktury_ns{s}, min(fit_values), mean(fit_values), max(fit_values))
    end
end
toc