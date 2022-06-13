addpath(genpath('beta_bursts/'))
addpath(genpath('mfeeg/'))
load ../datafiles/PopCurrent.mat
a = [3001 3010, 3019];






burst_pow = zeros(1,78);
burst_dur = zeros(1,78);
num_bursts = zeros(1,78);
burst_pow_save = zeros(1,3*78);
burst_dur_save = zeros(1,3*78);
num_bursts_save = zeros(1,3*78);
stats = zeros(4,3,3);
for i = 1:3
    
load(num2str(a(i))+"/Resting_State/VEf_b_1_48.mat")
numSecsDATA = size(VEf_b_1_48,2)/600;
 for j = 1:78
      bursts = beta_bursts(VEf_b_1_48(j,:),600);
      burst_dur(j) = mean(bursts.dur);
      burst_pow(j) = mean(bursts.pwr);
      num_bursts(j) = size(bursts.pwr,1)/numSecsDATA;
      burst_dur_save(j+78*(i-1)) = mean(bursts.dur);
      burst_pow_save(j+78*(i-1)) = mean(bursts.pwr);
      num_bursts_save(j+78*(i-1)) = size(bursts.pwr,1)/numSecsDATA;
      
       end
        stats(1,1,i) = mean(burst_dur(~isnan(burst_dur)));
        stats(2,1,i) = std(burst_dur(~isnan(burst_dur)));
        stats(3,1,i) = skewness(burst_dur(~isnan(burst_dur)));
        stats(4,1,i) = kurtosis(burst_dur(~isnan(burst_dur)));
        
      
        
        stats(1,2,i) = mean(num_bursts(~isnan(num_bursts)));
        stats(2,2,i) = std(num_bursts(~isnan(num_bursts)));
        stats(3,2,i) = skewness(num_bursts(~isnan(num_bursts)));
        stats(4,2,i) = kurtosis(num_bursts(~isnan(num_bursts)));

end

burst_dur_save = burst_dur_save(~isnan(burst_dur_save));
burst_pow_save = burst_pow_save(~isnan(burst_pow_save));
num_bursts_save = num_bursts_save(~isnan(num_bursts_save));
realdatastats = (stats(:,:,1) + stats(:,:,2) + stats(:,:,3))/3;
save('burst_dur_save.mat','burst_dur_save')
save('burst_pow_save.mat','burst_pow_save')
save('num_bursts_save.mat','num_bursts_save')
save('realDataStats.mat','realdatastats')
