%{
 
this program solves for losses and heat transfer in buck converters

types of losses:
 - switching loss  ( P = 1/2 Vin * I (Tc,on + Tc,off) fs ) 
 - gate charge loss( P = Qgate (c) * fs (1/sec) * Vgate )
 - conduction loss ( P = Rds * d * I^2 )
 - diode forward   ( P = (1-d) Vfm I )
 - diode reverse   ( P = 1/2 I_RRM t_b Vd_neg fs )
%} 

fs = 16e3;
synchronous = 1;

parallel = 3;

Rdson_perFET = 9e-3;
Vdiode = 1.3;

Qgate = 161e-9;
Vgate = 15;

Qrr = 633e-9;

Iout = 10;

Vin = 160;
Vout = 100;



Iout_perFET = Iout/parallel;

d = Vout ./ Vin;

if (synchronous == 1)
    P_conduction_perFET = Rdson_perFET * 1 * Iout_perFET^2;    
    P_diode_conduction_perFET = 0;
    P_gate_perFET = Qgate * fs * Vgate * 2;
else
    P_conduction_perFET = Rdson_perFET * d * Iout_perFET^2;
    P_diode_conduction_perFET = Vdiode * Iout_perFET;
    P_gate_perFET = Qgate * fs * Vgate;
end

P_reverse_recovery_perFET = Qrr * Vin * fs;

P_conduction_total = P_conduction_perFET * parallel;
P_diode_conduction_total = P_diode_conduction_perFET * parallel;
P_gate_total = P_gate_perFET * parallel;
P_reverse_recovery_total = P_reverse_recovery_perFET * parallel;

Pout = Vout * Iout;
P_loss = P_conduction_total + P_diode_conduction_total + P_gate_total + P_reverse_recovery_total;

fprintf('\n\nConduction Loss:\n');
fprintf('\t FET Per FET: %f W\n',P_conduction_perFET);
fprintf('\t FET Total: %f W\n',P_conduction_total);
fprintf('\t Diode Per FET: %f W\n',P_diode_conduction_perFET);
fprintf('\t Diode Total: %f W\n',P_diode_conduction_total);
fprintf('\t Per FET: %f W\n',P_diode_conduction_perFET + P_conduction_perFET);
fprintf('\t Total: %f W\n',P_diode_conduction_total + P_conduction_total);

fprintf('\nGate Drive Loss:\n');
fprintf('\t Per FET: %f W\n',P_gate_perFET);
fprintf('\t Total: %f W\n',P_gate_total);

fprintf('\nReverse Recovery Loss:\n');
fprintf('\t Per FET: %f W\n',P_reverse_recovery_perFET);
fprintf('\t Total: %f W\n',P_reverse_recovery_total);

fprintf('\nEfficiency: %f\n',Pout/(Pout+P_loss));

