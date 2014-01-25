close all;

bw = 200;

Rq = 50e-3*3/2;
Lq = .50e-3*3/2;

Teq = Lq/Rq;

figure('name','Plant');
Gplant = tf(1/Rq,[Teq 1]);

margin(Gplant)

sPlant = allmargin(Gplant);

fprintf('\n\n--- Plant (Motor) ---\n');
fprintf('Bandwidth: %f Hz\n',sPlant.PMFrequency/(2*pi));

%% MOHAN (REFERENCE ONLY)

% This is the mohan way to calculate Kp and Ki
ki = bw * 2 * pi * Rq;
kp = ki * Teq;
cntl = tf([kp ki],[1 0]);

%% PROPORTIONAL

% find the plant gain at the bw frequency, then adjust the kp to
% to make it the crossover.
Gp = 1/abs((1/Rq/(j*Teq*2*pi*bw+1)));

fprintf(' --- Proportional Term --- \n');
fprintf('Bandwidth: %f Hz\n',bw);
fprintf('Gp: %f\n',Gp);

figure('name','With proportional');
margin(Gplant*Gp);

%% INTEGRAL BOOST

% let's chose the wc frequency of the integral gain to be bw/4

wci = bw/4*2*pi;

Gi = tf([1 wci],[1 0]);

figure('name','With PI');
margin(Gplant*Gp*Gi)

fprintf(' --- Integral Term --- \n');
fprintf('Frequency: %f\n',wci/(2*pi));
fprintf('Ki: %f\n',wci*Gp);

%% ROLLOFF

% finally, add rolloff at 4*bw

wcr = bw*2*2*pi;

Gr = tf([wcr],[1 wcr]);

fprintf(' --- Rolloff Term --- \n');
fprintf('Frequency: %f\n',wcr/(2*pi));
fprintf('Divisor: %f\n',40000/(wcr/(2*pi)));

figure('name','With PI & R');
margin(Gplant*Gp*Gi*Gr);
