clear all;
close all;

iout = dlmread('iout.txt');
vin = dlmread('vin.txt');
vout = dlmread('vout.txt');
fs = dlmread('fs.txt');

subplot(221);

plot(vout(:,3),vout(:,7),'linewidth',2);

Vout_eff = zeros(1,length(vout));
for i = 1:length(vout)
    Vout_eff(i) = fsfxn(123, vout(i,3), 3,200e3);
end

hold on;
plot(vout(:,3),Vout_eff,'r','linewidth',2);
legend('Actual','Theortical');

title('V_{out} vs Efficiency (V_{in} = 123V, I_{out} = 3A)','fontweight','bold');
xlabel('V_{out} (volts)','fontweight','bold');
ylabel('Efficiency','fontweight','bold');
axis([min(vout(:,3)) max(vout(:,3)) .7 1])
grid on;

subplot(222);

plot(vin(:,1),vin(:,7),'linewidth',2);

Vin_eff = zeros(1,length(vin));
for i = 1:length(vin)
    Vin_eff(:,i) = fsfxn(vin(i,1),4,3,200e3);
end

hold on;
plot(vin(:,1),Vin_eff,'r','linewidth',2);
legend('Actual','Theortical');

title('V_{in} vs Efficiency (V_{out} = 4V, I_{out} = 3A)','fontweight','bold');
xlabel('V_{in} (volts)','fontweight','bold');
ylabel('Efficiency','fontweight','bold');
axis([min(vin(:,1)) max(vin(:,1)) .7 1])
grid on;

subplot(223);

plot(iout(:,4),iout(:,7),'linewidth',2);

Iout_eff = zeros(1,length(iout));
for i = 1:length(iout)
    Iout_eff(i) = fsfxn(123, 3.6, iout(i,4),200e3);
end

hold on;
plot(iout(:,4),Iout_eff,'r','linewidth',2);
legend('Actual','Theortical');

title('I_{out} vs Efficiency (V_{out} = 3.6V, V_{in} = 123V)','fontweight','bold');
xlabel('I_{out} (volts)','fontweight','bold');
ylabel('Efficiency','fontweight','bold');
axis([min(iout(:,4)) max(iout(:,4)) .7 1])
grid on;

subplot(224);

plot(fs(:,8),fs(:,7),'linewidth',2);

Fs_eff = zeros(1,length(fs));
for i = 1:length(fs)
    Fs_eff(i) = fsfxn(123, 3.6, 3,fs(i,8));
end

hold on;
plot(fs(:,8),Fs_eff,'r','linewidth',2);
legend('Actual','Theortical');

title('F_{s} vs Efficiency (V_{out} = 3.6V, V_{in} = 123V)','fontweight','bold');
xlabel('F_{s} (Hz)','fontweight','bold');
ylabel('Efficiency','fontweight','bold');
axis([min(fs(:,8)) max(fs(:,8)) .7 1])
grid on;
