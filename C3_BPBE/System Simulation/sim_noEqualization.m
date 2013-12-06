function [energy, heat, seconds] = sim_noEqualization(moduleSOC, moduleCapacity, currentProfile, moduleESR, timestep)

    heat = 0;       % heat disapated (J)               
    energy = 0;     % energy extracted from pack (mA-Hr)
    seconds = 0;    % seconds to kill (s)

    i = 0;
    
    while (min(moduleSOC) > 0)

        seconds = seconds + deltaT;
        i = i + 1;
        
        heatloss = current(i)^2*moduleESR;  % watts
        heat = heat + heatloss*timestep;    % joules
        
        soc = soc - current(i)*timestep - socheat; % mA-sec
        energy = energy + current(seconds);

    end


end

