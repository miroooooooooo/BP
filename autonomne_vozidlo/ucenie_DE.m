
sensorMode = 1; % vyber modu senzoru 1 -> radar, 2 -> kamera, 3 -> fúzia
map3 = Map(3);
map5 = Map(5);
car3 = Car(map3.startX, map3.startY, map3.startAngle, map3, sensorMode);
car5 = Car(map5.startX, map5.startY, map5.startAngle, map5, sensorMode);

% populacia o velkosti 50 a nasledne "populacia" pre skusobne retazce
nn = NN([50, 50], velkosti_vrstiev, 2);



fit1 = nn.fits.fit1;
fit2 = nn.fits.fit2;

pop1 = nn.populations.pop1;
pop2 = nn.populations.pop2;

space = nn.space;
ohranicenie = space;
space1 = space/5;
space2 = space/50;
space3 = space/500;

gens = 200;

F = 0.15;
CR = 0.6;
velkost_populacie = height(pop1);

fitParametersCount = 7;

fitS1temp = zeros(nn.populationSizes(1), fitParametersCount);

fitS1 = zeros(gens, fitParametersCount);

fitTrend1 = zeros(gens, 1);
tic

% vypocitame povodne fitness
fit = fit1;
parfor i = 1:nn.populationSizes(1,1)
% for i = 1:nn.populationSizes(1,1)
    [fit(i), ~] = ff_class(nn, map3, car3, 1, i);
    if fit(i) ~= inf
        [fit_car5, ~] = ff_class(nn, map5, car5, 1, i);
        fit(i) = fit(i) + fit_car5;
    end
end

for gen=1:gens

    [min_fit, min_index] = min(fit);
    nn = nn.fitTrendInsert(1, gen, min_fit);
    nn = nn.fitSepInsert(1, gen, fitS1temp(min_index, :));
    nn = nn.updateFit(1, fit);

    populacia = nn.populations.pop1;

    % a ideme hop sup robit novu generaciu
    nova_populacia = zeros(size(populacia));
    skusobne = zeros(size(populacia));

    for i = 1:height(populacia)
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

        % vypocet nahodneho "v"
        nahodny = populacia(r1,:) + F*(populacia(r2,:) - populacia(r3,:));
        
        % udrzanie v prehladavanom priestore
        nedodrzal_dolnu_hranicu = nahodny < space(1,:);
        nedodrzal_hornu_hranicu = nahodny > space(2,:);
        nahodny(nedodrzal_dolnu_hranicu) = space(1, nedodrzal_dolnu_hranicu);
        nahodny(nedodrzal_hornu_hranicu) = space(2, nedodrzal_hornu_hranicu);

        % vytvaranie noveho jedinca
        skusobny = zeros(1, width(populacia));
        for j = 1:width(populacia)
            if rand < CR
                skusobny(j) = nahodny(j); % gen z "v"
            else
                skusobny(j) = populacia(i, j); % gen z povodneho
            end
        end

        skusobne(i,:) = skusobny;
    end
    nn = nn.updatePop(2, skusobne);
    parfor i = 1:height(populacia)
        [fit_skusobna, ~] = ff_class(nn, map3, car3, 2, i);
        if fit_skusobna ~= inf
            [fit_car5, ~] = ff_class(nn, map5, car5, 2, i);
            fit_skusobna = fit_skusobna + fit_car5;
        end

        fit_povodna = fit(i); % tu sme si predtym vypocitali
        if fit_skusobna < fit_povodna % minimalizujeme
            nova_populacia(i,:) = skusobne(i,:);
            fit(i) = fit_skusobna;
        else
            nova_populacia(i,:) = populacia(i,:);
        end
    end

    nn = nn.updatePop(1, nova_populacia);
end
[min_fit, min_index] = min(fit);
nn = nn.updateFit(1, fit);
nn = nn.selectBest(1, 1);
toc