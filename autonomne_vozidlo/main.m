% ----------- %
close all
clc
clear
% ----------- %
%%
figure('Position', [100, 100, 800, 500]);

variant = 5; % vyber variantu mapy [3, 5] -> mapy určené pre testovanie
sensorMode = 3; % vyber modu senzoru 1 -> radar, 2 -> kamera, 3 -> fúzia
map = Map(variant); 
car = Car(map.startX, map.startY, map.startAngle, map, sensorMode);

% podla typu senzoru zvolime architektúru NS
switch sensorMode
    case 1
        nn = NN([100 100 45], [10 6 6 2], 2);
    case 2
        nn = NN([100 100 45], [10 6 6 2], 2);
    case 3
        nn = NN([100 100 45], [20 10 10 2], 2);
end    

car.drawCar(1);
%%  Pred-inicializacia matíc -> ušetrenie rýchlosti
fit1 = nn.fits.fit1;
fit2 = nn.fits.fit2;
fit3 = nn.fits.fit3;

fitPrev1 = fit1;
fitPrev2 = fit2;
fitPrev3 = fit3;
checkpointsReached1 = zeros(nn.populationSizes(1), 1);
checkpointsReached2 = zeros(nn.populationSizes(2), 1);
checkpointsReached3 = zeros(nn.populationSizes(3), 1);

pop1 = nn.populations.pop1;
pop2 = nn.populations.pop2;
pop3 = nn.populations.pop3;

space = nn.space;
space1 = space/5;
space2 = space/50;
space3 = space/500;

gens = 999;

fitParametersCount = 7;

fitS1temp = zeros(nn.populationSizes(1), fitParametersCount);
fitS2temp = zeros(nn.populationSizes(2), fitParametersCount);
fitS3temp = zeros(nn.populationSizes(1), fitParametersCount);

fitS1 = zeros(gens, fitParametersCount);
fitS2 = zeros(gens, fitParametersCount);
fitS3 = zeros(gens, fitParametersCount);

fitTrend1 = zeros(gens, 1);
fitTrend2 = zeros(gens, 1);
fitTrend3 = zeros(gens, 1);
%% Genetický algoritmus

for i = 1:gens
    dFit1 = fit1 - fitPrev1;
    dFit2 = fit2 - fitPrev2;
    dFit3 = fit3 - fitPrev3;

    if mod(i, 1) == 0
        fprintf("------------ Current generation: %d  ------------\n", i)
    end

    parfor j = 1:nn.populationSizes(1,1)
        [fit1(j), checkpointsReached1(j), fitS1temp(j,:)] = fitness(nn, map, car, 1, j);
    end
    
    parfor j = 1:nn.populationSizes(1,2)
        [fit2(j), checkpointsReached2(j), fitS2temp(j,:)] = fitness(nn, map, car, 2, j);
    end

    parfor j = 1:nn.populationSizes(1,3)
        [fit3(j), checkpointsReached3(j), fitS3temp(j,:)] = fitness(nn, map, car, 3, j);
    end

    nn.fits.fit1 = fit1;
    % 1. ostrov - Genetické operácie
    best_1 = selbest(pop1, fit1, [1, 1]);
    old_1 = selrand(pop1, fit1, 10);
    work1a_1 = seltourn(pop1, fit1, 10);
    work1b_1 = seltourn(pop1, fit1, 10);
    work1_1 = [work1a_1; work1b_1; best_1];

    work2a_1 = seltourn(pop1, fit1, 10);
    work2b_1 = seltourn(pop1, dFit1, 10);
    work2_1 = [work2a_1; work2b_1; best_1];

    work3a_1 = selsus(pop1, fit1, 10);
    work3b_1 = selsus(pop1, dFit1, 10);
    work3_1 = [work3a_1; work3b_1; best_1];

    work4a_1 = selsus(pop1, fit1, 10);
    work4b_1 = selsus(pop1, dFit1, 10);
    work4_1 = [work4a_1; work4b_1; best_1];

    work1_1 = crossov(work1_1, 4, 0);
    work2_1 = mutx(work2_1, 0.2, space);
    work3_1 = muta(work3_1, 0.15, space2, space);
    work4_1 = muta(work4_1, 0.18, space3, space);

    pop1 = [best_1; work1_1; work2_1; work3_1; work4_1; old_1];

    % 2. ostrov - Genetické operácie
    best_2 = selbest(pop2, fit2, [1, 1]);
    old_2 = selrand(pop2, fit2, 10);
    work1a_2 = seltourn(pop2, fit2, 10);
    work1b_2 = seltourn(pop2, fit2, 10);
    work1_2 = [work1a_2; work1b_2; best_2];

    work2a_2 = seltourn(pop1, fit1, 10);
    work2b_2 = seltourn(pop1, dFit2, 10);
    work2_2 = [work2a_2; work2b_2; best_2];

    work3a_2 = selsus(pop1, fit1, 10);
    work3b_2 = selsus(pop1, dFit2, 10);
    work3_2 = [work3a_2; work3b_2; best_2];

    work4a_2 = selsus(pop1, fit1, 10);
    work4b_2 = selsus(pop1, dFit2, 10);
    work4_2 = [work4a_2; work4b_2; best_2];

    work1_2 = intmedx(work1_2, 0.5);
    work2_2 = mutx(work2_2, 0.15, space);
    work3_2 = muta(work3_2, 0.1, space2, space);
    work4_2 = muta(work4_2, 0.15, space3, space);
    pop2 = [best_2; work1_2; work2_2; work3_2; work4_2; old_2];

    % 3. ostrov - Genetické operácie
    best_3 = selbest(pop3, fit3, [2, 1, 1, 1]);
    work_3 = selbest(pop3, fit3, [1,1,1,1,1,1,1,1,1,1]);

    work1_3 = muta1(work_3, space2, space);
    work2_3 = muta1(work_3, space2, space);
    work3_3 = muta1(work_3, space1, space);
    work4_3 = muta1(work_3, space1, space);
    pop3=[best_3; work1_3; work2_3; work3_3; work4_3];

    nn = nn.updatePop(1, pop1);
    nn = nn.updatePop(2, pop2);
    nn = nn.updatePop(3, pop3);

    % migracia z ostrova 1 do ostrova 2, z ostrova 3 do 1, zahrievanie ostrova 1,
    if mod(i, 100)==0
        pop3(10, :) = pop1(1,:);  % migracia z Pop_1 do Pop_3
        pop3(11, :) = pop2(1,:);  % migracia z Pop_2 do Pop_3
        pop2(10, :) = pop1(1,:);
        pop1(10, :) = pop2(1,:);

        popa_1 = pop1(1:50, :);
        popb_1 = pop1(51:100, :);
        popa_1 = warmpopm(popa_1, 0.3); % zahreje 1. polovicu populacie 1
        popb_1 = warmpopm(popb_1, 0.6); % zahreje 2. polovicu populacie 1
        pop1 = [popa_1; popb_1];

        [nn, pop2] = nn.resetPop(2); % reset druhého ostrova
    end

    % Vloženie fitness trendov
    nn = nn.fitTrendInsert(1, i, min(fit1));
    nn = nn.fitTrendInsert(2, i, min(fit2));
    nn = nn.fitTrendInsert(3, i, min(fit3));

    % minimum fitness funkcie a indexy daným chromozómov
    [~, index] = min(fit1);
    [~, index2] = min(fit2);
    [~, index3] = min(fit3);

    % Vloženie separátnych fitness funckií - zložky
    nn = nn.fitSepInsert(1, i, fitS1temp(index, :));
    nn = nn.fitSepInsert(2, i, fitS2temp(index2, :));
    nn = nn.fitSepInsert(3, i, fitS3temp(index3, :));

    % Vypísanie max. checkpointov, ktoré boli v danej generácií dosiahnuté
    maxCheckpointsReached1 = checkpointsReached1(index);
    maxCheckpointsReached2 = checkpointsReached2(index2);
    maxCheckpointsReached3 = checkpointsReached3(index3);

    fprintf("------------ Checkpoints reached:\n")
    cprintf('red'," 1. island: %d  \n", maxCheckpointsReached1)
    cprintf('red'," 2. island: %d  \n", maxCheckpointsReached2)
    cprintf('red'," 3. island: %d  \n", maxCheckpointsReached3)
end


%% Testovanie
clear xs ys;
figure('Position', [100, 100, 800, 500]);
testVariant = 4; % variant testovacich map [4, 6]
testMap = Map(testVariant);
step = 0;
sensorMode = 3; % % výber módu senzoru 1 -> radar, 2 -> kamera, 3 -> fúzia
popIndex = 2; % index populacie, ktoru chceme otestovat
geneIndex = 2; % index jedinca, ktoreho chceme otestovat
testNN = load("NNMap05TrainedFusionWithFitSeps.mat").nn; % Načítanie NS zo súboru
% testNN = nn; % Načítanie NS z aktuálneho trénovania
[testNN, weights] = testNN.convertWeights(popIndex, geneIndex); 
car = Car(testMap.startX, testMap.startY, testMap.startAngle, testMap, sensorMode);
car.drawCar(2)
%% Simulácia vykreslenia
speeds = zeros(testMap.maxSteps, 1);

while ~testMap.checkFinish(car.carPosition)
    [sensorReadings, cameraReadings] = car.getSensorReadings();
    switch car.sensorMode
        case 1
            [out] = testNN.evaluateOutput(sensorReadings, pi/4, weights, popIndex, geneIndex); % get output angle
        case 2
            [out] = testNN.evaluateOutput(cameraReadings, pi/4, weights, popIndex, geneIndex); % get output angle
        case 3
            [out] = testNN.evaluateOutput([sensorReadings, cameraReadings'], pi/4, weights, popIndex, geneIndex); % get output angle
    end
    car = car.update(out(1), out(2));
    car.drawCar(2);
    pause(0.0001);
    step = step + 1;
    xs(step) = car.carPosition(1);
    ys(step) = car.carPosition(1,2);
    speeds(step) = car.speed / car.multiplyParameters;
end 

% imshow(testMap.image)
%% Vykreslenie trajektorie

car.drawCar();
hold on
plot(xs(:), ys(:), 'X', 'Color', '#80c3ff');
set(gca, 'Ydir', 'reverse')
hold off

%% Vykreslenie fitness
figure
generations = 1:1:999;
plot(generations, nn.fitTrend.pop1)