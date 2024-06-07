close all; clear; clc;

algoritmy = {"GA", "GA_ostrovny", "DE", "PSO"};
struktury_ns = {"4_6_6_1", "4_10_10_1", "4_15_15_1"};

pocet_zbehnuti = 10;

for algo=1:length(algoritmy)
    for s=1:length(struktury_ns)
        figure("Name", strcat(algoritmy{algo}, "___", struktury_ns{s}));
        tiledlayout(2,2);

        fit_values = zeros(1,pocet_zbehnuti);

        for run=1:pocet_zbehnuti
            filename = strcat(algoritmy{algo}, "___", struktury_ns{s}, "___", num2str(run), ".mat");
            load(filename);
            nexttile(1); % vyvoj fitness
            hold on;
            plot(1:maxgen, fit_hodnoty(1:length(1:maxgen)), "DisplayName", strcat("Spustenie č. ", num2str(run)));
            xlabel("generácia")
            ylabel("hodnota účelovej funkcie")
            legend("show")
            set(gca, "fontsize", 14)

            nexttile(2); % zoom na fitness
            hold on;
            if algoritmy{algo} == "GA_ostrovny"
                fit_hodnoty = evo1;
            end
            plot(1:maxgen, fit_hodnoty(1:length(1:maxgen)), "DisplayName", strcat("Spustenie č. ", num2str(run)));
            xlabel("generácia")
            ylabel("hodnota účelovej funkcie")
            legend("show")
            set(gca, "fontsize", 14)
            ylim([3500, 8500])
            xlim([100, maxgen])

            % vypocita hodnotu fitness pre testovaci scenar
            [W, B] = vector_to_W_B(najlepsi,velkosti_vrstiev);
            [e,y,w,u,t] = sim_ncFF1test(W{1}, W{2}, W{3}, B{1}, B{2});
            test_fitness = sum(abs(e))+2e1*sum(abs(diff(y)))+0.1*sum(abs(diff(u)));

            nexttile(3);
            hold on;
            bar(categorical(run), test_fitness, 'b');
            xlabel("Poradie spustenia")
            ylabel("hodnota účelovej funkcie pre testovací scenár")
            set(gca, "fontsize", 14)

            nexttile(4);
            hold on;
            bar(categorical(run), test_fitness, 'b');
            ylim([0, 8500]);
            xlabel("Poradie spustenia")
            ylabel("hodnota účelovej funkcie pre testovací scenár")
            set(gca, "fontsize", 14)

            fit_values(run) = test_fitness;
            sprintf("%s, run no. %d, fitness: %f", algoritmy{algo}, run, test_fitness)
        end


        sprintf("%s %s, min fit: %f, mean fit: %f, max fit: %f", algoritmy{algo}, struktury_ns{s}, min(fit_values), mean(fit_values), max(fit_values))
    end
end