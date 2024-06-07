tic

neuronka;

velkost_populacie = 50;
pocet_premennych = length(W_B_to_vector(W,B,velkosti_vrstiev));

ohranicenie = prehladavny_priestor;

% nahodne zgeneruj zaciatocnu populaciu
populacia = genrpop(velkost_populacie, ohranicenie);

maxgen = 500;
F = 0.15;
CR = 0.6;

fit_hodnoty = zeros(maxgen, 1);

fit = neuro_regulator_fit_par(populacia, velkosti_vrstiev);

for gen=1:maxgen
    [min_fit, max_fit] = bounds(fit);
    fit_hodnoty(gen) = min_fit;

%     najlepsi = selbest(populacia, fit, [1]); % chcem niekde na konci/zaciatku zobrat najlepsieho nech vieme, ze ci sme fit
    % tu by malo byt podmienene ukoncenie

    % a ideme hop sup robit novu generaciu
    nova_populacia = zeros(size(populacia));
    skusobne = zeros(size(populacia));

    for i = 1:height(populacia)
        % 1.
        % zgeneruj rozne nahodne indexy jedincov
        r1 = randi([1, velkost_populacie]);
        r2 = randi([1, velkost_populacie]);
        r3 = randi([1, velkost_populacie]);
        while r2 == r1
            r2 = randi([1, velkost_populacie]);
        end
        while r3 == r2 || r3 == r1
            r3 = randi([1, velkost_populacie]);
        end
        % v = nahodny
        nahodny = populacia(r1,:) + F*(populacia(r2,:) - populacia(r3,:));
        
        % udrzanie v prehladavanom priestore
        nedodrzal_dolnu_hranicu = nahodny < ohranicenie(1,:);
        nedodrzal_hornu_hranicu = nahodny > ohranicenie(2,:);
        nahodny(nedodrzal_dolnu_hranicu) = ohranicenie(1, nedodrzal_dolnu_hranicu);
        nahodny(nedodrzal_hornu_hranicu) = ohranicenie(2, nedodrzal_hornu_hranicu);

        % 2.
        % u = skusobny
        skusobny = zeros(1, width(populacia));
        for j = 1:width(populacia)
            if rand < CR
                % alebo tu nerobit srandu ak nie je na <min;max>?
                skusobny(j) = nahodny(j); % gen z "v"
            else
                skusobny(j) = populacia(i, j); % gen z povodneho
            end
        end
        skusobne(i,:) = skusobny;
    end

    fit_skusobne = neuro_regulator_fit_par(skusobne, velkosti_vrstiev);
    for i = 1:height(populacia)
        % 3.
        fit_skusobna = fit_skusobne(i);
        fit_povodna = fit(i); % to sme si na zaciatku vypocitali
        if fit_skusobna < fit_povodna % minimalizujeme
            nova_populacia(i,:) = skusobne(i,:);
            fit(i) = fit_skusobna;
        else
            nova_populacia(i,:) = populacia(i,:);
        end
    end

    populacia = nova_populacia;
end
toc
najlepsi = selbest(populacia, fit, [1]);
