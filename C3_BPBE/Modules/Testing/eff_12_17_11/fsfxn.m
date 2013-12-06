function eff = fsfxn(Vin, Vout, Idc,fs)
%function [Ptotal,Ploss] = fsfxn(Vin, Vout, Idc, fs)

% Inductor Choice: 
% Page: 4-14 (71)
% 16.6 mm OD
% MPP P/N: 58118
% 18 AWG - N=24 - R = 13.3mOhms

% Transformer Choice
% Bobbin: PCB1808B1
% Core: 0F41808EC
% 80 windings of 24 gauge, 8 windings of 18 gauge (maybe use 16 AWG)


% Inductor Copper Properties
L_Rcopper = 13.3e-3*2;    % 18 AWG (page 103) (x2 for 2 24 gauge)
NL = 24;                % 24 turns of 18 gauge fit on 1 layer.

% Transformer Copper Properties
N1 = 60;
N2 = 8;
T_RcopperPri = 3.25*0.08422;
T_RcopperSec = .007123*2; % (x2 for 2 24 gauge) 

% Switching Frequency
%fs = 200e3;

% Inductor Core properties
lm = 41.2e-3;
am = 19.2e-6;
ur = 160 * 0.80;  % we are at about 80 percent of u with a Idc = 3
uo = 4*pi*1e-7;
L_v = .791;

% Transformer Core Properties
T_Ac = 22.1e-6; %39.5e-6;
T_lc = 39.9e-3; %49e-3;
T_ur = 1500;
T_v = .900; % cm^-3

% Diode Properties
Dr_on = 0.4;
Df_on = 0.4;

% Converter Properties
%Idc = 3;
%Vin = 96;
%Vout = 3.65;

% ===================================================
%           Inductor Property Calculations 
% ===================================================

L_Reluc = lm/(ur*uo*am);
L_L = NL^2/L_Reluc;
L_phi = NL*Idc/L_Reluc;
L_B = L_phi/am;

% ===================================================
%           Converter Calculations 
% ===================================================

Ts = 1/fs;
D = Vout/Vin * N1/N2;

Iripple = (Vin*(N2/N1)-Vout)/L_L*D*Ts;

% ===================================================
%           Diode Calculations 
% ===================================================

%Estimate - I'm too lazy to do the actual math...
DR_Ploss = Dr_on*Idc*D;
DF_Ploss = Df_on*Idc*(1-D);

% ===================================================
%           Copper Loss 
% ===================================================

L_Pcopper = Idc^2 * L_Rcopper;

% These are approximations...
T_PcopperSec = Idc^2 * T_RcopperSec;
T_PcopperPri = (Idc*N2/N1)^2 * T_RcopperPri;

% ===================================================
%           Inductor Core Loss 
% ===================================================

% From page 31, the slope is about u, so we approximate :
L_B_ACmax = NL*(Idc + Iripple/2)/L_Reluc/am;
L_B_ACmin = NL*(Idc - Iripple/2)/L_Reluc/am;
L_Bpk = (L_B_ACmax-L_B_ACmin)/2;

L_a = 446.6;
L_b = 2.3;
L_c = 1.41;

L_Pcore = (L_a * L_Bpk^L_b * (fs/1e3)^L_c) * L_v / 1000;


% ===================================================
%           Transformer Property Calculations 
% ===================================================

T_Reluc = T_lc/(T_ur*uo*T_Ac);
T_Lpri = N1^2/T_Reluc;
T_Lsec = N2^2/T_Reluc;
T_phi = D * Vin / (N1 *fs);
T_B = T_phi/T_Ac;

% Using F amterial properties
T_a = 0.0573;
T_c = 1.66;
T_d = 2.68;

T_Pcore = T_a * (fs/1000)^T_c * T_B^T_d / 1000 * T_v;

% this is the switching loss at fs, 110Vin, 3A out
swloss = 5.56e-6*fs;%(5.5683e-006) * fs;

Ploss = L_Pcopper + L_Pcore + T_PcopperSec + T_PcopperPri + T_Pcore + DR_Ploss + DF_Ploss + swloss;
Ptotal = Vout * Idc + Ploss;
eff = (Ptotal-Ploss)/Ptotal;


