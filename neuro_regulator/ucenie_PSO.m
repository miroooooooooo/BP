tic

neuronka;

velkost_populacie = 50;
pocet_premennych = length(W_B_to_vector(W,B,velkosti_vrstiev));

ohranicenie = prehladavny_priestor;

maxgen = 500;

c0 = repmat(0.5, 1, pocet_premennych);
c1 = repmat(1.25, 1, pocet_premennych);
c2 = repmat(1.8, 1, pocet_premennych);


% nahodne zgeneruj zaciatocnu populaciu
populacia = genrpop(velkost_populacie, ohranicenie);
lokalne_najlepsi = populacia;  % pbest, najlepsie hodnoty pre jednotlivych jedincov
rychlosti = genrpop(velkost_populacie, ohranicenie);

% vyhodnotenie fit a vyber najlepsieho
fit = neuro_regulator_fit_par(populacia, velkosti_vrstiev);
fit_lokalne_najlepsi = fit;
najlepsi = selbest(populacia, fit, [1]); % gbest
fit_najlepsi = neuro_regulator_fit_par(najlepsi, velkosti_vrstiev);

fit_hodnoty = zeros(1, maxgen);

for gen=1:maxgen
    nove_rychlosti =    c0 .* rychlosti ...
                      + c1 .* rand(size(rychlosti)) .* (lokalne_najlepsi - populacia) ...
                      + c2 .* rand(size(rychlosti)) .* (repmat(najlepsi, height(rychlosti), 1) - populacia);

    populacia = populacia + nove_rychlosti;
    rychlosti = nove_rychlosti;

    % lock na <min; max>
    dolne_ohranicenie_bool = ohranicenie(1,:) > populacia;
    populacia = ((ones(1, width(populacia)) - dolne_ohranicenie_bool) .* populacia) + (dolne_ohranicenie_bool .* ohranicenie(1,:));
    horne_ohranicenie_bool = ohranicenie(2,:) < populacia;
    populacia = ((ones(1, width(populacia)) - horne_ohranicenie_bool) .* populacia) + (horne_ohranicenie_bool .* ohranicenie(2,:));

    % vyhodnotenie fit a vyber najlepsieho
    fit = neuro_regulator_fit_par(populacia, velkosti_vrstiev);
    for i = 1:height(populacia)
        fit_hodnota = fit(i);
        if fit_hodnota < fit_lokalne_najlepsi(i)
            lokalne_najlepsi(i,:) = populacia(i,:);
            fit_lokalne_najlepsi(i) = fit_hodnota;

            if fit_hodnota < fit_najlepsi
                najlepsi = lokalne_najlepsi(i,:);
                fit_najlepsi = fit_lokalne_najlepsi(i);
            end
        end
    end

    % na vygenerovanie grafu
    fit_hodnoty(gen) = fit_najlepsi;
end
toc