N = 4;              % Number of FETs in parallel
RdsOn = 8e-3;       % On-state resistance of the FETs
Qg_total = 161e-9;  % Total gate charge
Qgs = 54e-9;        % Gate-Source charge
Qgd = 52e-9;        % Gate-Drain charge
Vgs_th = 4;         % Threshold voltage
Vpl = 6.5;          % Plateau voltage

RgInternal = 1;     % Internal mosfet gate resistance


Vgd = 15;               % Gate drive voltage
RgExternalCharge = 6.8; % External gate resistance (charge)
RgExternalDisch  = 2.7; % External gate resistance (discharge)
VGateDiode = 0.5;        % Forward voltage of the discharge diode

Fs = 20000;    % Switching Frequency

Vbus = 120;    % Bus voltage
Vout = 30;     % Output voltage
Iavg = 30;     % Average output current

Lll = 0.002;   % Line to Line motor inductance

% ===============================================================

% Ripple Current

Iripple = (Vbus-Vout)*(Vout/Vbus)*1/Fs/Lll;

% ===============================================================

% Build a gate charge vs gate voltage profile
% (like illustrated in the datasheet)

Vgs   = [0 Vpl Vpl Vgd ];
q = [0 Qgs Qgs+Qgd Qg_total ];

% ===============================================================

% High Side Turn-On

% Solve for Gate current (Ig), Gate Voltage (Vg), and
% gate charge (Qg).

dt = 1e-10;
t = 0:dt:0.2e-6;

Ig_on = zeros(1,length(t));
Qg_on = zeros(1,length(t));
Vg_on = zeros(1,length(t));

Ig_off = zeros(1,length(t));
Qg_off = zeros(1,length(t));
Vg_off = zeros(1,length(t));

Ig_off(1) = 0;
Qg_off(1) = Qg_total;
Vg_off(1) = Vgd;


for i = 2:length(t)
    Qg_on(i) = Qg_on(i-1) + Ig_on(i-1)*dt;
    Vg_on(i) = interp1(q,Vgs,Qg_on(i));
    Ig_on(i) = (Vgd-Vg_on(i))/(RgInternal+RgExternalCharge);

    Qg_off(i) = Qg_off(i-1) - Ig_on(i-1)*dt;
    Vg_off(i) = interp1(q,Vgs,Qg_off(i));
    Ig_off(i) = (Vg_off(i)-VGateDiode-RgInternal*Ig(i-1))/(RgExternalDisch) ...
        + (Vg_off(i)-RgInternal*Ig(i-1))/(RgExternalCharge);
end

% Plot the Results

subplot(311);
plot(t.*1e9,Qg_on.*1e9,'linewidth',2);
hold on;
plot(t.*1e9,Qg_off.*1e9,'g','linewidth',2);
ylabel('Qg (nC)','fontweight','bold');
legend('Turn-On','Turn-Off');

subplot(312);
plot(t.*1e9,Vg_on,'linewidth',2);
hold on;
plot(t.*1e9,Vg_off,'g','linewidth',2);
ylabel('Vg (V)','fontweight','bold');

subplot(313);
plot(t.*1e9,Ig_on,'linewidth',2);
hold on;
plot(t.*1e9,Ig_off,'g','linewidth',2);
ylabel('Ig (A)','fontweight','bold');
xlabel('Time (ns)','fontweight','bold')

% Next, let's calcualte the loss when the current starts flowing
% and the voltage remains at vbus

t_Vth_on = t(sum(Vg_on<Vgs_th));
t_Vpl_on= t(sum(Vg_on<Vpl));
t_Vpl2_on = t(sum(Vg_on<=Vpl));

tri = t_Vpl_on-t_Vth_on;
tfv = t_Vpl2_on-t_Vpl_on;


t_Vpl2_off = t(sum(Vg_off>Vpl));
t_Vpl_off = t(sum(Vg_off>=Vpl));
t_Vth_off = t(sum(Vg_off>Vgs_th));

trv = t_Vpl_off - t_Vpl2_off;
tfi = t_Vth_off - t_Vpl2_off;

P_high_on = Vbus*Iavg*0.5*tri*Fs + Vbus*Iavg*0.5*tfv*Fs;
P_high_off = Vbus*Iavg*0.5*trv*Fs + Vbus*Iavg*0.5*tfi*Fs;

P_high = P_high_on + P_high_off

% The first thing we can calculate is the loss due to gate drive
% current:

%P_gate_drive = trapz(t,Ig*Vgd)*N*6*Fs;
%fprintf('Ripple Current: %.3f A\n',Iripple);
