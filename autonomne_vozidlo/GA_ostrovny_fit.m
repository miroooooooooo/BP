function [fit] = GA_ostrovny_fit(nn, popIndex, car3, car5, map3, map5, ff_class)
    % vypocita fitness pre celu populaciu na ostrove
    pocet_jedincov = nn.populationSizes(popIndex);
    fit = zeros(pocet_jedincov, 1);

    parfor i = 1:pocet_jedincov
        [fit(i), ~] = ff_class(nn, map3, car3, popIndex, i);
        if fit(i) ~= inf
            [fit_car5, ~] = ff_class(nn, map5, car5, popIndex, i);
            fit(i) = fit(i) + fit_car5;
        end
    end
end

