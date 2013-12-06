fs = 200e3;

lm = 39.9e-3;
am = 22.6e-6;
lg = 0;
ur = 3000;
uo = 4*pi*1e-7;

I = .2;
N = 50;

% Calculate basic magnetic parameters
R = lm/(ur*uo*am) + lg/(uo*am);
L = N^2/R;
B = phi/am;
phi = N*I/R;

% Core loss estimate for F material in
% 100-500kHz range.
a = .0573;
c = 1.66;
d = 2.68;
pcore = a*(fs/1e3)^c*(B/10)^d;

Rpri = 

fprintf('\n\nR = %f A/Wb\n',R);
fprintf('L = %f uH\n',L/1e6);
fprintf('%c = %f Wb\n',248,phi);
fprintf('B = %f T\n',B);
fprintf('Pcore = %f W\n',pcore);

