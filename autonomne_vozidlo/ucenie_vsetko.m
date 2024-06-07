close all; clear; clc;

fprintf('%s : Začiatok učenia\n', datetime)

addpath('genetic');

pocet_spusteni = 1;
pocet_lucov = 7;
pocet_vstupov = pocet_lucov+1; % pripocitame 1 vstup pre rychlost
pocet_vystupov = 2;
vsetky_velkosti_vrstiev = {[pocet_vstupov 6 6 pocet_vystupov], [pocet_vstupov 10 10 pocet_vystupov], [pocet_vstupov 15 15 pocet_vystupov]};
ff_class = @fitness_custom;

for spustenie = 1:pocet_spusteni
    for a = 1:length(vsetky_velkosti_vrstiev)
        velkosti_vrstiev = vsetky_velkosti_vrstiev{a};
        fprintf('%s : GA obyčajný - vrstvy NS [%s], spustenie č. %d\n', datetime, strjoin(string(velkosti_vrstiev), ','), spustenie)
        ucenie_GA_obycajny;
        save(append('GA_obycajny___', strjoin(string(velkosti_vrstiev), '_'), '___', string(spustenie), '.mat'));
        clearvars -except populacie a vsetky_velkosti_vrstiev spustenie pocet_spusteni ff_class;
    end

    for a = 1:length(vsetky_velkosti_vrstiev)
        velkosti_vrstiev = vsetky_velkosti_vrstiev{a};
        fprintf('%s : GA ostrovný - vrstvy NS [%s], spustenie č. %d\n', datetime, strjoin(string(velkosti_vrstiev), ','), spustenie)
        ucenie_GA_ostrovny;
        save(append('GA_ostrovny___', strjoin(string(velkosti_vrstiev), '_'), '___', string(spustenie), '.mat'));
        clearvars -except populacie a vsetky_velkosti_vrstiev spustenie pocet_spusteni ff_class;
    end

    for a = 1:length(vsetky_velkosti_vrstiev)
        velkosti_vrstiev = vsetky_velkosti_vrstiev{a};
        fprintf('%s : DE - vrstvy NS [%s], spustenie č. %d\n', datetime, strjoin(string(velkosti_vrstiev), ','), spustenie)
        ucenie_DE;
        save(append('DE___', strjoin(string(velkosti_vrstiev), '_'), '___', string(spustenie), '.mat'));
        clearvars -except a vsetky_velkosti_vrstiev spustenie pocet_spusteni ff_class;
    end

    for a = 1:length(vsetky_velkosti_vrstiev)
        velkosti_vrstiev = vsetky_velkosti_vrstiev{a};
        fprintf('%s : PSO - vrstvy NS [%s], spustenie č. %d\n', datetime, strjoin(string(velkosti_vrstiev), ','), spustenie)
        ucenie_PSO;
        save(append('PSO___', strjoin(string(velkosti_vrstiev), '_'), '___', string(spustenie), '.mat'));
        clearvars -except a vsetky_velkosti_vrstiev spustenie pocet_spusteni ff_class;
    end
end

fprintf('%s : Koniec učenia\n', datetime)