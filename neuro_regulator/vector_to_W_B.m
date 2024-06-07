function [W, B] = vector_to_W_B(vektor, velkosti_vrstiev)

pocet_vrstiev = numel(velkosti_vrstiev);
W = cell(1, pocet_vrstiev-1);
B = cell(1, pocet_vrstiev-2);

predosli_koniec = 1;

for i = 1:pocet_vrstiev - 1
    novy_koniec = predosli_koniec - 1 + velkosti_vrstiev(i+1)*velkosti_vrstiev(i);
    W{i} = reshape(vektor(predosli_koniec:novy_koniec), [velkosti_vrstiev(i) velkosti_vrstiev(i+1)]);
    predosli_koniec = novy_koniec+1;  % zaciname az od nasledujuceho prvku
end

for i = 1:pocet_vrstiev - 2
    novy_koniec = predosli_koniec - 1 + velkosti_vrstiev(i+1);
    B{i} = vektor(predosli_koniec:novy_koniec);
    predosli_koniec = novy_koniec + 1;
end

