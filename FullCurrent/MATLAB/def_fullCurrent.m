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
Vq = 100;    

for Ipeak = [5 10 15 20 30 40 50 60 70 80 90 100]
    
    [Ia Ib Ic V1 V2 V3 VN] = foc(Ipeak, Vq, Vbus, false);

    P_loss1 = zeros(1,length(Ia));
    P_loss2 = zeros(1,length(Ia));
    P_loss3 = zeros(1,length(Ia));
    P_switching_loss1 = zeros(1,length(Ia));
    P_switching_loss2 = zeros(1,length(Ia));
    P_switching_loss3 = zeros(1,length(Ia));
    P_gate_drive1 = zeros(1,length(Ia));
    P_gate_drive2 = zeros(1,length(Ia));
    P_gate_drive3 = zeros(1,length(Ia));
    P_reverse1 = zeros(1,length(Ia));
    P_reverse2 = zeros(1,length(Ia));
    P_reverse3 = zeros(1,length(Ia));
    P_conduction1 = zeros(1,length(Ia));
    P_conduction2 = zeros(1,length(Ia));
    P_conduction3 = zeros(1,length(Ia));

    parfor i = 1:length(Ia)
        [P_loss1(i), P_switching_loss1(i), P_gate_drive1(i), P_reverse1(i), P_conduction1(i)] ...
                    = fullCurrent.Loss(Vbus, V1(i), VN(i), Ia(i), false);

        %[P_loss2(i), P_switching_loss2(i), P_gate_drive2(i), P_reverse2(i), P_conduction2(i)] ...
        %            = fullCurrent.Loss(Vbus, V2(i), VN(i), Ib(i), false);

        %[P_loss3(i), P_switching_loss3(i), P_gate_drive3(i), P_reverse3(i), P_conduction3(i)] ...
        %            = fullCurrent.Loss(Vbus, V3(i), VN(i), Ic(i), false);

        %fprintf('%i\n',i)
    end

    Pout = (Vq/sqrt(2))*Ipeak/sqrt(2);
    Ploss = mean(P_loss1 + P_loss1 + P_loss1);
    P_switching_loss = mean(P_switching_loss1 + P_switching_loss1 + P_switching_loss1);
    P_gate_drive = mean(P_gate_drive1 + P_gate_drive1 + P_gate_drive1);
    P_reverse = mean(P_reverse1 + P_reverse1 + P_reverse1);
    P_conduction = mean(P_conduction1 + P_conduction1 + P_conduction1);

    Eff = Pout / (Ploss + Pout);


    fprintf('%9.1fV(B) %9.1fV(Q) %9.1fA(PH) %9.1fW(SW) %9.1fW(GD) %9.1fW(RR) C%9.1fW(CO) %9.1fW(E)\n', ...
        Vbus,Vq,Ipeak,P_switching_loss,P_gate_drive,P_reverse,P_conduction,Eff*100);

end

    
