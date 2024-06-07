tic


neuronka;

velkost_populacie = 50;
pocet_premennych = length(W_B_to_vector(W,B,velkosti_vrstiev));
maxgen = 500;

ohranicenie = prehladavny_priestor;
aditivna_hranice = abs(ohranicenie(1,:))/100;

pop1 = genrpop(velkost_populacie, ohranicenie);
pop2 = genrpop(velkost_populacie, ohranicenie);
pop3 = genrpop(velkost_populacie, ohranicenie);

evo1 = zeros(1, maxgen+1);
evo2 = zeros(1, maxgen+1);
evo3 = zeros(1, maxgen+1);

for gen=1:maxgen+1
    
    if mod(gen,5)==0
       pop1(end,:) = pop3(1,:);
       pop2(end,:) = pop3(1,:);
       pop1(end-1,:) = pop2(1,:);
    end
    if mod(gen,50)==0
        pop3 = genrpop(velkost_populacie, ohranicenie);
    end

    if mod(gen,80)==0
        pop2 = warming(pop2, 0.2,ohranicenie);
    end
    % vyhodnotenie fit
    [fit1] = neuro_regulator_fit_par(pop1, velkosti_vrstiev);
    [fit2] = neuro_regulator_fit_par(pop2, velkosti_vrstiev);
    [fit3] = neuro_regulator_fit_par(pop3, velkosti_vrstiev);

    evo1(gen) = min(fit1);
    evo2(gen) = min(fit2);
    evo3(gen) = min(fit3);

    pop1 = GA_ostrovny_operacie(pop1, fit1, ohranicenie, aditivna_hranice);
    pop2 = GA_ostrovny_operacie(pop2, fit2, ohranicenie, aditivna_hranice);
    pop3 = GA_ostrovny_operacie(pop3, fit3, ohranicenie, aditivna_hranice);

end
fit1 = neuro_regulator_fit_par(pop1, velkosti_vrstiev);

toc

najlepsi = selbest(pop1,fit1,1);
