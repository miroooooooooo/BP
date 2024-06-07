
sensorMode = 1; % vyber modu senzoru 1 -> radar, 2 -> kamera, 3 -> fúzia
map3 = Map(3);
map5 = Map(5);
car3 = Car(map3.startX, map3.startY, map3.startAngle, map3, sensorMode);
car5 = Car(map5.startX, map5.startY, map5.startAngle, map5, sensorMode);

% populacie v poradi: pozicie, najlepsie pozicie (pbest), rychlosti
nn = NN([50, 50, 50], velkosti_vrstiev, 2);

gens = 200;

pop = nn.populations.pop1;
pbest = nn.populations.pop2;
nn = nn.updatePop(2, pop); % nastavime pbest
rychlosti = nn.populations.pop3;

space = nn.space;


% parametre PSO
c0 = repmat(0.5, 1, width(pop));
c1 = repmat(1.25, 1, width(pop));
c2 = repmat(1.8, 1, width(pop));


velkost_populacie = height(pop);


tic

fitTrend1 = zeros(gens, 1);
fit = nn.fits.fit1;
% vypocitame povodne fitness
parfor i = 1:nn.populationSizes(1,1)
    [fit(i), ~] = ff_class(nn, map3, car3, 1, i);
    if fit(i) ~= inf
        [fit_car5, ~] = ff_class(nn, map5, car5, 1, i);
        fit(i) = fit(i) + fit_car5;
    end
end
nn = nn.updateFit(2, fit); % nastavenie fit pre pbest
pbest_fit = nn.fits.fit2;

nn = nn.selectBest(1, 1);
gbest = nn.populations.pop1(nn.bestIndex, :);
gbest_fit = fit(nn.bestIndex);

for gen=1:gens
    for i = 1:height(pop)
        % vypocitanie rychlosti
        rychlosti(i,:) =    c0 .* rychlosti(i,:) ...
                            + c1 .* rand(size(pop(i,:))) .* (pbest(i,:) - pop(i,:)) ...
                            + c2 .* (rand(size(pop(i,:)))) .* (gbest - pop(i,:));
        pop(i,:) = pop(i,:) + rychlosti(i,:);

        % udrzanie v prehladavanom priestore
        nedodrzal_dolnu_hranicu = pop(i,:) < space(1,:);
        nedodrzal_hornu_hranicu = pop(i,:) > space(2,:);
        pop(i, nedodrzal_dolnu_hranicu) = space(1, nedodrzal_dolnu_hranicu);
        pop(i, nedodrzal_hornu_hranicu) = space(2, nedodrzal_hornu_hranicu);
    end
    
    nn = nn.updatePop(1,pop);

    parfor i = 1:height(pop)
        [fit(i), ~] = ff_class(nn, map3, car3, 1, i);
        [fit_car5, ~] = ff_class(nn, map5, car5, 1, i);
        fit(i) = fit(i) + fit_car5;
    end

    for i = 1:height(pop)
        % porovnanie aktualnej fitness s pbest
        if fit(i) < pbest_fit(i)
            pbest(i,:) = pop(i,:);
            pbest_fit(i) = fit(i);
        end
        % porovnanie aktualnej fitness s gbest
        if pbest_fit(i) < gbest_fit
            gbest = pbest(i,:);
            gbest_fit = pbest_fit(i);
        end
    end

    nn = nn.fitTrendInsert(1, gen, gbest_fit);

    nn = nn.updateFit(1, fit);
    nn = nn.updateFit(2, pbest_fit);

    nn = nn.updatePop(1, pop);
    nn = nn.updatePop(2, pbest);
    nn = nn.updatePop(3, rychlosti);
end
% zistime index pre gbest, aby sme mohli spustit simulaciu
nn = nn.selectBest(2, 1);

toc