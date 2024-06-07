% vytvori cell arrays pre matice vah a vektory biasov
% velkosti_vrstiev = [4, 15, 15, 1]; % vratane vstupnej a vystupnej

pocet_vrstiev = numel(velkosti_vrstiev);

W = cell(1, pocet_vrstiev-1);
B = cell(1, pocet_vrstiev-2);

for i = 1:pocet_vrstiev - 1
    W{i} = ones(velkosti_vrstiev(i+1), velkosti_vrstiev(i));
end

for i = 1:pocet_vrstiev - 2
    B{i} = ones(velkosti_vrstiev(i+1), 1);
end

prehladavny_priestor = [
    repmat([-1;1], 1, velkosti_vrstiev(1)*velkosti_vrstiev(2))... % spojenia prva -> druha vrstva
    repmat([-1;1], 1, velkosti_vrstiev(2)*velkosti_vrstiev(3)), ... % spojenia druha -> tretia vrstva
    repmat([-100;100], 1, velkosti_vrstiev(3)*velkosti_vrstiev(4)), ... % spojenia druha -> tretia vrstva
    repmat([-1;1], 1, velkosti_vrstiev(2)), ... % biasy 
    repmat([-1;1], 1, velkosti_vrstiev(3)) % biasy 
];