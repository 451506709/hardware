freq = csvread('v3.2_3-24-12_freq.csv');
iout = csvread('v3.2_3-24-12_iout.csv');
vin =  csvread('v3.2_3-24-12_vin.csv');
vout = csvread('v3.2_3-24-12_vout2.csv');

subplot(221);

plot(vout(:,4),vout(:,6)/100,'linewidth',2);

%{ 
Vout_eff = zeros(1,length(vout));
for i = 1:length(vout)
    Vout_eff(i) = fsfxn(123, vout(i,3), 3,200e3);
end

hold on;
plot(vout(:,3),Vout_eff,'r','linewidth',2);
legend('Actual','Theortical');
%}

title('V_{out} vs Efficiency (V_{in} = 111V, I_{out} = 2.5A)','fontweight','bold');
xlabel('V_{out} (volts)','fontweight','bold');
ylabel('Efficiency','fontweight','bold');

axis([min(vout(:,4)) max(vout(:,4)) .7 1])
grid on;

subplot(222);

plot(vin(:,2),vin(:,6)/100,'linewidth',2);

%{
Vin_eff = zeros(1,length(vin));
for i = 1:length(vin)
    Vin_eff(:,i) = fsfxn(vin(i,1),4,3,200e3);
end

hold on;
plot(vin(:,1),Vin_eff,'r','linewidth',2);
legend('Actual','Theortical');
%}

title('V_{in} vs Efficiency (V_{out} = 3.6V, I_{out} = 2.5A)','fontweight','bold');
xlabel('V_{in} (volts)','fontweight','bold');
ylabel('Efficiency','fontweight','bold');
axis([min(vin(:,2)) max(vin(:,2)) .7 1])
grid on;

subplot(223);

plot(iout([1:15],5),iout([1:15],6)/100,'b','linewidth',2);
hold on;
plot(iout([16:22],5),iout([16:22],6)/100,'g','linewidth',2);
plot(iout([23:30],5),iout([23:30],6)/100,'r','linewidth',2);


%{
Iout_eff = zeros(1,length(iout));
for i = 1:length(iout)
    Iout_eff(i) = fsfxn(123, 3.6, iout(i,4),200e3);
end

hold on;
plot(iout(:,4),Iout_eff,'r','linewidth',2);
legend('Actual','Theortical');
%}

title('I_{out} vs Efficiency (V_{in} = 111V)','fontweight','bold');
xlabel('I_{out} (volts)','fontweight','bold');
ylabel('Efficiency','fontweight','bold');
axis([min(iout(:,5)) max(iout(:,5)) .7 1])
legend('V_{out} = 3.6V','V_{out} = 4.1V','V_{out} = 2.6V'); 
grid on;

subplot(224);

plot(freq(:,7),freq(:,6)/100,'linewidth',2);
%{
Fs_eff = zeros(1,length(fs));
for i = 1:length(fs)
    Fs_eff(i) = fsfxn(123, 3.6, 3,fs(i,8));
end

hold on;
plot(fs(:,8),Fs_eff,'r','linewidth',2);
legend('Actual','Theortical');
%}

title('F_{s} vs Efficiency (V_{out} = 3.6V, V_{in} = 111V)','fontweight','bold');
xlabel('F_{s} (Hz)','fontweight','bold');
ylabel('Efficiency','fontweight','bold');
axis([min(freq(:,7)) max(freq(:,7)) .7 1])
grid on;