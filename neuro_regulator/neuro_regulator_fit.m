function [fit,e,y,w,u,t] = neuro_regulator_fit(ch, velkosti_vrstiev)
    % vypocita fitness pre daneho jedinca
    [W, B] = vector_to_W_B(ch,velkosti_vrstiev);
    W1 = W{1};
    W2 = W{2};
    W3 = W{3};
    B1 = B{1};
    B2 = B{2};
    [e,y,w,u,t] = sim_ncFF1(W1,W2,W3,B1,B2);
%     [e,y,w,u,t] = sim_ncFF1test(W1,W2,W3,B1,B2);
    fit=sum(abs(e))+2e1*sum(abs(diff(y)))+0.1*sum(abs(diff(u)));
end