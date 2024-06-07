function [newpop] = GA_ostrovny_operacie(pop,fit, ohranicenie, aditivna_hranice)
    najlepsi = selbest(pop, fit, [1 1]);
    
    work1 = [najlepsi; seltourn(pop,fit,8)];
    work2 = [najlepsi; selrand(pop,fit,8)];
    work3 = [selsus(pop,fit,18)];
    work4 = [selbest(pop,fit,[1,1,1,1,1])];
    new = genrpop(5, ohranicenie);
    
    work1 = crossov(work1, 2, 0);
    work3 = crossov(work3, 3, 0);
   
    work1 = mutx(work1, 0.07, ohranicenie);
    work2 = mutx(work2, 0.12, ohranicenie);
    work3 = mutx(work3, 0.09, ohranicenie);
    work4 = muta(work4, 0.15, aditivna_hranice./10, ohranicenie);
    work1 = muta(work1, 0.10, aditivna_hranice, ohranicenie);
    work3 = muta(work3, 0.12, aditivna_hranice, ohranicenie);
    
    newpop = [najlepsi; work1; work2; work3; work4; new];
end