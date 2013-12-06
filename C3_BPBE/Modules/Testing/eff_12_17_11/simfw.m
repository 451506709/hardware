clear all;

Vin = 96:1:125;
Vin_eff = zeros(1,30);

for i = 1:30
    Vin_eff(i) = fsfxn(Vin(i), 4, 3);
end

plot(Vin,Vin_eff);