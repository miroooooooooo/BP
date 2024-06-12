close all; clear; clc;

fprintf('%s : Začiatok učenia\n', datetime)

addpath('genetic');

pocet_spusteni = 1;

pocet_vstupov = 4;
pocet_vystupov = 1;
vsetky_velkosti_vrstiev = {[pocet_vstupov 6 6 pocet_vystupov], [pocet_vstupov 10 10 pocet_vystupov], [pocet_vstupov 15 15 pocet_vystupov]};

for a=1:length(vsetky_velkosti_vrstiev)
    velkosti_vrstiev = vsetky_velkosti_vrstiev{a};
    for spustenie=1:pocet_spusteni
        fprintf('%s : GA obyčajný, vrstvy NS %s, spustenie č. %d\n', string(datetime), strjoin(string(velkosti_vrstiev), '_'), spustenie)
        ucenie_GA;
        save(append('GA_obycajny___', strjoin(string(velkosti_vrstiev), '_'), '___', string(spustenie), '.mat'));
        clearvars -except vsetky_velkosti_vrstiev velkosti_vrstiev spustenie a pocet_spusteni;
        
        fprintf('%s : GA ostrovný, vrstvy NS %s, spustenie č. %d\n', string(datetime), strjoin(string(velkosti_vrstiev), '_'), spustenie)
        ucenie_GA_ostrovny;
        save(append('GA_ostrovny___', strjoin(string(velkosti_vrstiev), '_'), '___', string(spustenie), '.mat'));
        clearvars -except vsetky_velkosti_vrstiev velkosti_vrstiev spustenie a pocet_spusteni;

        fprintf('%s : DE, vrstvy NS %s, spustenie č. %d\n', string(datetime), strjoin(string(velkosti_vrstiev), '_'), spustenie)
        ucenie_DE;
        save(append('DE___', strjoin(string(velkosti_vrstiev), '_'), '___', string(spustenie), '.mat'));
        clearvars -except vsetky_velkosti_vrstiev velkosti_vrstiev spustenie a pocet_spusteni;

        fprintf('%s : PSO, vrstvy NS %s, spustenie č. %d\n', string(datetime), strjoin(string(velkosti_vrstiev), '_'), spustenie)
        ucenie_PSO;
        save(append('PSO___', strjoin(string(velkosti_vrstiev), '_'), '___', string(spustenie), '.mat'));
        clearvars -except vsetky_velkosti_vrstiev velkosti_vrstiev spustenie a pocet_spusteni;
    end
end

fprintf('%s : Koniec učenia\n', datetime)
