addpath(genpath('beta_bursts/'))
addpath(genpath('mfeeg/'))
load ../datafiles/PopCurrent.mat
sizePop = size(popcurrent,3);
stats  = zeros(4,2,sizePop); % rows, 3 coloumns .....
stats(:) = NaN;
numTrials = size(popcurrent,2);

srate = 500;


numSecsSims = size(popcurrent,1)/srate;


burst_pow = zeros(1,numTrials);
burst_dur = zeros(1,numTrials);
num_bursts = zeros(1,numTrials);
for i = 1:sizePop
       for j = 1:numTrials
         bursts = beta_bursts(popcurrent(:,j,i),srate);
         burst_dur(j) = mean(bursts.dur);
         burst_pow(j) = mean(bursts.pwr);
         num_bursts(j) = size(bursts.pwr,1)/numSecsSims;
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



save('../datafiles/ThresholdStats.mat','stats')