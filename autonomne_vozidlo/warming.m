%************* Autor: Filip Zubek, Ivan Sekaj *************
% 
% Funkcia pre zahrievanie populacie s nahodnym sumom, urcenym % mierou z pracovneho rozsahu
% 
% d_pop -> Zahriata populacia
% pop -> Populacia ktora ma byt zahriata
% rate -> maximalna % miera z rozsahu daneho maticou space
% space -> matica urcujuca pracovny rozsah (min; max pre kazdy parameter)

function [d_pop]=warming(pop, rate, space)
    dist = space*rate;
    s_pop = size(pop);
    d_pop = zeros(s_pop); 
    r_dist = zeros(1,s_pop(2));
    
    for j=1:length(dist)
        r_dist(j) = dist(randi(2),j)*rand();
    end

    for i=1:s_pop(1)
        t_pop = pop(i,:) + r_dist;
        for j=1:s_pop(2)
            if t_pop(j) > space(2,j)
                 t_pop(j) = space(2,j);
            end
            if t_pop(j) < space(1,j)
                t_pop(j) = space(1,j);
            end
        end
        d_pop(i,:) = t_pop;
    end
end

