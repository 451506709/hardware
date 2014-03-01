IRFP4668 = MosfetSwitch();
    IRFP4668.RdsOn = 8e-3;
    IRFP4668.QgTotal = 161e-9;
    IRFP4668.Qgs = 54e-9;
    IRFP4668.Qgd = 52e-9;
    IRFP4668.Vth = 4;
    IRFP4668.Vpl = 6.5;
    IRFP4668.RgInternal = 1;
    IRFP4668.Qrr = 633e-9;
    
duber = Motor();
    duber.L_LN = 0.001;
    duber.R_LN = 0.050;
    duber.KE = 0.5;

fullCurrent = MotorController();
    fullCurrent.N = 4;
    fullCurrent.VGateDrive = 15;
    fullCurrent.RgExternalCharge = 6.8;
    fullCurrent.RgExternalDischarge = 2.7;
    fullCurrent.VGateDiode = 0.5;
    fullCurrent.Fs = 20000;
    fullCurrent.mosfet = IRFP4668;
    fullCurrent.motor = duber;
    


    
    
