% funkcia na simulaciu regulacie s neuro-regulatorom, bez simulinku

function[e,y,w,u,t]=sim_ncFF1test(W1,W2,W3,B1,B2)

Ts=0.05; % perioda riadenia
Tsim=100; % doba simulacie

t=zeros(1,Tsim/Ts); y=zeros(1,Tsim/Ts); d1y=zeros(1,Tsim/Ts); 
w=zeros(1,Tsim/Ts); u=zeros(1,Tsim/Ts); 
e=zeros(1,Tsim/Ts); de=zeros(1,Tsim/Ts); ie=zeros(1,Tsim/Ts); dy=zeros(1,Tsim/Ts);

% init. riadeneho dynamickeho systemu
t1=0; u0=0; u1=0; du0=0; y0=0; y1=0; dy1=0; dy0=0;ddy1=0;ddy0=0;
d1u1=0; d1y1=0; d2y1=0; e0=0;
ww=0; uu=0; ie1=0;  
umax=30;  % maximalny vystup
ddy1=0;


Ne=1/40; Nde=1/400; Nie=1/2e2; Nd1y=1/20; Nd1u=1/umax; Ny=1/40; % normy vstupov NC

% ------------ cyklus simulacie URO

for k=1:(Tsim/Ts)  
    
%--------- cas, vstupy, vystupy
    t(k)=t1+Ts; % --- t
    t1=t(k);

% testovaci scenar regulacie  
    if t(k)>=80
        ww=6;
    elseif t(k)>=65
        ww=0;
    elseif t(k)>=48
        ww=13;
    elseif t(k)>=27
        ww=5;
    elseif t(k)>=12
        ww=18;      
    elseif t(k)>=5
        ww=8;    
    end
    
    ww = ww*1.0;
% ----------------------------------- simulacia systemu

    dddy0=(0.1*u0-0.16*y0-0.56*dy0-3.4*ddy0); % system
    ddy0=ddy1+dddy0*Ts;
    dy0=dy1+ddy0*Ts;
    y0=y1+dy0*Ts;
    du0=(u0-u1)/Ts;
    
% ------------- neuro-regulator vstupy, meranie

    d1y=(y0-y1)/Ts;
    d2y=(d1y-d1y1)/Ts;
    d3y=(d2y-d2y1)/Ts;
    d2y1=d2y;
    d1y1=d1y;
            
    d1u=(u0-u1)/Ts;
    d2u=(d1u-d1u1)/Ts;  % derivacia u
    d1u1=d1u;
       
    dy1=dy0; 
    y(k)=y0;
    u(k)=u0; 
    y1=y0; 
    u1=u0; 
    ddy1 = ddy0;
    
    w(k)=ww;
    e(k)=y(k)-w(k);
    de(k)= (e0 - e(k))/Ts;
    e0 = e(k);
    ie(k)=ie1+e(k)*Ts;
    ie1=ie(k);
    dy(k)=d1y;
    
    % vektor vstupov do neuro-regulatora
    X=[e(k)*Ne de(k)*Nde ie(k)*Nie d1y*Nd1y];   

% vypocet vystupu neuronovej    siete ---------------
   
   % 1. tanh
    A1=(X*W1)+B1;    % vstupna -> 1.skryta vrstva
    O1=tanh(A1*3);

    A2=(O1*W2)+B2;   % 1. -> 2. skryta vrstva
    O2=tanh(A2*3);
    
    A3=O2*W3;

    uu=A3;
    u0=uu*umax;
    u(k)=u0;

end