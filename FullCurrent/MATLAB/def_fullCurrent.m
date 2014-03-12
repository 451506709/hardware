IRFP4668 = MosfetSwitch();
    IRFP4668.RdsOn = 8e-3;
    IRFP4668.QgTotal = 161e-9;
    IRFP4668.Qgs = 54e-9;
    IRFP4668.Qgd = 52e-9;
    IRFP4668.Vth = 4;
    IRFP4668.Vpl = 6.5;
    IRFP4668.RgInternal = 1;
    IRFP4668.Qrr = 633e-9;
    
STFET = MosfetSwitch();
    STFET.RdsOn = 10e-3;
    STFET.QgTotal = 338e-9;
    STFET.Qgs = 47e-9;
    STFET.Qgd = 183e-9;
    STFET.Vth = 3;
    STFET.Vpl = 5.25;
    STFET.RgInternal = 1.4;
    STFET.Qrr = 2.4e-9;
    
duber = Motor();
    duber.L_LN = 0.0005;
    duber.R_LN = 0.050;
    duber.KE = 0.5;

fullCurrent = MotorController();
    fullCurrent.N = 2;
    fullCurrent.VGateDrive = 15;
    fullCurrent.RgExternalCharge = 6.8/2;
    fullCurrent.RgExternalDischarge = 2.7;
    fullCurrent.VGateDiode = 0.5;
    fullCurrent.Fs = 4000;
    fullCurrent.mosfet = IRFP4668;
    fullCurrent.motor = duber;

Vbus = 130;
Vqs = [10 20 30 40 50 60 70 80 90 100];    
Ipeaks = [5 10 15 20 30 40 50 60 70 80 90 100];

P_switching_loss = zeros(length(Vqs),length(Ipeaks));
P_gate_drive = zeros(length(Vqs),length(Ipeaks));
P_reverse = zeros(length(Vqs),length(Ipeaks));
P_conduction = zeros(length(Vqs),length(Ipeaks));
Eff = zeros(length(Vqs),length(Ipeaks));

for i = 1:(length(Vqs))
    Vq = Vqs(i);
    
    for j = 1:(length(Ipeaks))
        Ipeak = Ipeaks(j);
        
        [Ia, Ib, Ic, V1, V2, V3, VN] = foc(Ipeak, Vq, Vbus, false);

        P_loss_ = zeros(1,length(Ia));
        P_switching_loss_ = zeros(1,length(Ia));
        P_gate_drive_ = zeros(1,length(Ia));
        P_reverse_ = zeros(1,length(Ia));
        P_conduction_ = zeros(1,length(Ia));

        for k = 1:length(Ia)
            [P_loss_(k), P_switching_loss_(k), P_gate_drive_(k), P_reverse_(k), P_conduction_(k)] ...
                        = fullCurrent.Loss(Vbus, V1(k), VN(k), Ia(k), false);
        end

        Pout = (Vq/sqrt(2))*Ipeak/sqrt(2);
        Ploss = mean(P_loss_ + P_loss_ + P_loss_);
        P_switching_loss(i,j) = mean(P_switching_loss_ + P_switching_loss_ + P_switching_loss_);
        P_gate_drive(i,j) = mean(P_gate_drive_ + P_gate_drive_ + P_gate_drive_);
        P_reverse(i,j) = mean(P_reverse_ + P_reverse_ + P_reverse_);
        P_conduction(i,j) = mean(P_conduction_ + P_conduction_ + P_conduction_);

        Eff(i,j) = Pout / (Ploss + Pout);

        fprintf('%9.1fV(B) %9.1fV(Q) %9.1fA(PH) %9.1fW(SW) %9.1fW(GD) %9.1fW(RR) C%9.1fW(CO) %9.1fW(E)\n', ...
            Vbus,Vq,Ipeak,P_switching_loss(i,j),P_gate_drive(i,j),P_reverse(i,j),P_conduction(i,j),Eff(i,j)*100);
    end
end
    

figure;
surf(Ipeaks,Vqs,Eff)

