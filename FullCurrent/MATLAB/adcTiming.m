sys_clock = 168e6;
apb2_prescaler = 2;
adc_clkscaker = 4;

ts_min = 100e-9;
tcon_min = 500e-9;

tconv_cyc = 12;

% note this is channels per ADC
channelCount = 6;

fprintf('\n---------------------------\n');

adc_freq = sys_clock / apb2_prescaler / adc_clkscaker;
fprintf('\nADC Clock Frequency : %d Hz\n',adc_freq);
fprintf('ADC Clock Period    : %f ns\n',1/adc_freq*1e9);
tconv = 1/adc_freq * tconv_cyc;

if tconv < tcon_min
    fprintf('\nInvalid TCONV Cycle Count.\nSet to %fns, must be greater than %fns.\n',tconv*1e9,tcon_min*1e9);
end

fprintf('ADC Conversion Time : %f ns\n',tconv*1e9);

ts_cyc = [3 15 28 56 84 112 144 480];
ts_time = 1/adc_freq * ts_cyc;

ts_cyc = ts_cyc(ts_time > ts_min);
ts_time = ts_time(ts_time > ts_min);

treading = (ts_time + tconv).*channelCount;

max_freq = 1./treading';

fprintf('\nMax Sampling Frequencies:\n')
for i=1:length(max_freq)
   fprintf('Ts Cyc=%-3d : %f\n',ts_cyc(i),max_freq(i)); 
end





