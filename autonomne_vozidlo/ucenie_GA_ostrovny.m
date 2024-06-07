
sensorMode = 1; % vyber modu senzoru 1 -> radar, 2 -> kamera, 3 -> fúzia
map3 = Map(3);
map5 = Map(5);
car3 = Car(map3.startX, map3.startY, map3.startAngle, map3, sensorMode);
car5 = Car(map5.startX, map5.startY, map5.startAngle, map5, sensorMode);

% velkosti populacii = 50, 50, 50
nn = NN([50, 50, 50], velkosti_vrstiev, 2);

gens = 200;

fit1 = nn.fits.fit1;
fit2 = nn.fits.fit2;
fit3 = nn.fits.fit2;

fit = [fit1, fit2, fit3];

pop1 = nn.populations.pop1;
pop2 = nn.populations.pop2;
pop3 = nn.populations.pop3;

space = nn.space;
aditivna_hranice = abs(space(1,:))/100;

tic
for gen=1:gens

    pop1 = nn.populations.pop1;
    pop2 = nn.populations.pop2;
    pop3 = nn.populations.pop3;

    if mod(gen,5)==0
       pop1(end,:) = pop3(1,:);
       pop2(end,:) = pop3(1,:);
       pop1(end-1,:) = pop2(1,:);
    end
    if mod(gen,50)==0
        pop3 = genrpop(nn.populationSizes(3), nn.space);
    end
    
    if mod(gen,80)==0
        pop2 = warming(pop2, 0.2, space);
    end
    
    fit1 = GA_ostrovny_fit(nn, 1, car3, car5, map3, map5, ff_class);
    fit2 = GA_ostrovny_fit(nn, 2, car3, car5, map3, map5, ff_class);
    fit3 = GA_ostrovny_fit(nn, 3, car3, car5, map3, map5, ff_class);

    min_fit1 = min(fit1);
    min_fit2 = min(fit2);
    min_fit3 = min(fit3);
    
    nn = nn.fitTrendInsert(1, gen, min_fit1);
    nn = nn.fitTrendInsert(2, gen, min_fit2);
    nn = nn.fitTrendInsert(3, gen, min_fit3);
    
    nn = nn.updateFit(1, fit1);
    nn = nn.updateFit(2, fit2);
    nn = nn.updateFit(3, fit3);

    pop1 = GA_ostrovny_operacie(pop1, fit1, space, aditivna_hranice);
    pop2 = GA_ostrovny_operacie(pop2, fit2, space, aditivna_hranice);
    pop3 = GA_ostrovny_operacie(pop3, fit3, space, aditivna_hranice);
    
    nn = nn.updatePop(1, pop1);
    nn = nn.updatePop(2, pop2);
    nn = nn.updatePop(3, pop3);
end
[min_fit, min_index] = min(fit);

nn = nn.updateFit(1, fit(:,1));
nn = nn.updateFit(2, fit(:,2));
nn = nn.updateFit(3, fit(:,3));
% vyber najlepsieho jedinca
nn = nn.selectBest(1, 1);

toc
