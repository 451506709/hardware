classdef MotorController
    
    properties
        N
        VGateDrive
        RgExternalCharge
        RgExternalDischarge
        VGateDiode
        Fs
        mosfet
        motor
    end
    
    methods
        
        function [PHigh PLow] = SwitchingLoss(mc, V, plot)
            
            % Build a gate charge vs gate voltage profile
            % (like illustrated in the datasheet)
            Vgs   = [0 mc.mosfet.Vpl mc.mosfet.Vpl mc.VGateDrive ];
            q = [0 mc.mosfet.Qgs mc.mosfet.Qgs+mc.mosfet.Qgd mc.mosfet.QgTotal ];

            % Timestep for gate-drive charging
            dt = 1e-10;
            t = 0:dt:0.2e-6;

            % Specify initial conditions for on and off.
            Ig_on = zeros(1,length(t));
            Qg_on = zeros(1,length(t));
            Vg_on = zeros(1,length(t));

            Ig_off = zeros(1,length(t));
            Qg_off = zeros(1,length(t));
            Vg_off = zeros(1,length(t));

            Ig_off(1) = 0;
            Qg_off(1) = mc.mosfet.QgTotal;
            Vg_off(1) = mc.VGateDrive;

            for i = 2:length(t)
                % Calculate the gate waveforms for turn-on
                Qg_on(i) = Qg_on(i-1) + Ig_on(i-1)*dt;
                Vg_on(i) = interp1(q,Vgs,Qg_on(i));
                Ig_on(i) = (Vgd-Vg_on(i))/(mc.mosfet.RgInternal+mc.RgExternalCharge);
            
                % Then determine the turn-off waveforms
                Qg_off(i) = Qg_off(i-1) - Ig_on(i-1)*dt;
                Vg_off(i) = interp1(q,Vgs,Qg_off(i));
                Ig_off(i) = (Vg_off(i)-mc.VGateDiode-mc.mosfet.RgInternal*Ig_off(i-1))...
                    /(mc.RgExternalDischarge) ...
                    + (Vg_off(i)-mc.mosfet.RgInternal*Ig_off(i-1))/(mc.RgExternalCharge);
            end
                           
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

            
        end

    end
    
end

