Fs = 20000;
Ts = 1/Fs;
dt = 1e-10;

t = 0:dt:Ts;

vin = 120;
vout = 30;

d = vout/vin;

vgate = 15;

tDead = 5e-9;

% start half way through a cycle
% center aligned pwm

Ton = Ts / 

gate = zeros(1,length(t));
gate(t > Ts-