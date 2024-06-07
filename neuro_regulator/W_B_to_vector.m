function [vektor] = W_B_to_vector(W, B, velkosti_vrstiev)

pocet_vrstiev = numel(velkosti_vrstiev);
pocty_prvkov_W = velkosti_vrstiev(1:pocet_vrstiev-1) .* velkosti_vrstiev(2:pocet_vrstiev);

dlzka_vektora_W = sum(pocty_prvkov_W);
dlzka_vektora_B = sum(velkosti_vrstiev(2:pocet_vrstiev-1));

vektor = zeros(1, dlzka_vektora_W + dlzka_vektora_B);

vektor_poz = 0;

for i = 1:numel(W)
    vektor(vektor_poz + (1:pocty_prvkov_W(i))) = reshape(W{i}', 1, []);
    vektor_poz = vektor_poz + pocty_prvkov_W(i);
end

for i = 1:numel(B)
    vektor(vektor_poz + (1:velkosti_vrstiev(i+1))) = transpose(B{i});
    vektor_poz = vektor_poz + velkosti_vrstiev(i+1);
end

end

