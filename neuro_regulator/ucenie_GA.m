tic

neuronka;

velkost_populacie = 50;
pocet_premennych = length(W_B_to_vector(W,B,velkosti_vrstiev));

ohranicenie = prehladavny_priestor;

% nahodne zgeneruj zaciatocnu populaciu
populacia = genrpop(velkost_populacie, ohranicenie);


maxgen = 500;

fit_hodnoty = zeros(maxgen, 1);


tic;
for gen=1:maxgen

    % vyhodnotenie fit
    fit = neuro_regulator_fit_par(populacia, velkosti_vrstiev);

    [min_fit, max_fit] = bounds(fit);
    fit_hodnoty(gen) = min_fit;

    % vyber
    najlepsi = selbest(populacia, fit, [1 1]);

    kriziaci = [
        najlepsi;
        selrand(populacia, fit, 11);
        selsus(populacia, fit, 15);
        seltourn(populacia, fit, 15);
        genrpop(5, ohranicenie);
    ];


    % krizenie
    mutanti = crossov(kriziaci, 1, 0);

    % mutacia
    mutanti = mutx(mutanti, 0.1, ohranicenie);
    mutanti = muta(mutanti, 0.1, ohranicenie/500, ohranicenie);
    
    populacia = [najlepsi; mutanti];
end
toc


najlepsi = najlepsi(1,:);