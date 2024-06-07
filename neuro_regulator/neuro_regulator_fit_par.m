function [fit] = neuro_regulator_fit_par(populacia, velkosti_vrstiev)
    % vrati fitness pre danu populaciu
    poph = height(populacia);
    fit = zeros(1,poph);
    parfor i=1:poph
        [fit(i),~,~,~,~,~] = neuro_regulator_fit(populacia(i,:), velkosti_vrstiev);
    end
end