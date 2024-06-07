
sensorMode = 1; % vyber modu senzoru 1 -> radar, 2 -> kamera, 3 -> fúzia
map3 = Map(3);
map5 = Map(5);
car3 = Car(map3.startX, map3.startY, map3.startAngle, map3, sensorMode);
car5 = Car(map5.startX, map5.startY, map5.startAngle, map5, sensorMode);

% jedna populacia o velkosti 50
nn = NN([50], velkosti_vrstiev, 2);

gens = 200;

fit = nn.fits.fit1;
fitTrend1 = zeros(gens, 1);

pop1 = nn.populations.pop1;

space = nn.space;

tic
for gen=1:gens

    parfor i = 1:nn.populationSizes(1,1)
        [fit(i), ~] = ff_class(nn, map3, car3, 1, i);
        if fit(i) ~= inf
            [fit_car5, ~] = ff_class(nn, map5, car5, 1, i);
            fit(i) = fit(i) + fit_car5;
        end
    end

    [min_fit, min_index] = min(fit);
    nn = nn.fitTrendInsert(1, gen, min_fit);
    nn = nn.updateFit(1, fit);

    pop1 = nn.populations.pop1;

    % vyber
    najlepsi = selbest(pop1, fit, [1 1]);

    % skupina, ktoru pouzijeme na krizenie
    kriziaci = [
        najlepsi;
        selrand(pop1, fit, 11);
        selsus(pop1, fit, 15);
        seltourn(pop1, fit, 15);
        genrpop(5, space);
    ];


    % krizenie, dalej na tu istu skupinu pouzijeme mutaciu
    mutanti = crossov(kriziaci, 1, 0);

    % mutacia
    mutanti = mutx(mutanti, 0.1, nn.space);
    mutanti = muta(mutanti, 0.1, repmat(space/500, 1, nn.spaceLength), nn.space);
    nova_populacia = [najlepsi; mutanti];

    pop1 = nova_populacia;
    nn = nn.updatePop(1, pop1);
end
[min_fit, min_index] = min(fit);

nn = nn.updateFit(1, fit);
nn = nn.selectBest(1, 1);
toc
