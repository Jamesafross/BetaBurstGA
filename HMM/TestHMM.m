
clear all; close all;
parpool('Threads')

homedir=getuserdir()
addpath(genpath(append(homedir,'BetaBurstGA','/HMM-MAR/')));
addpath(genpath(append(homedir,'BetaBurstGA','/nutmeg/')));
ls(homedir)
cd(append(homedir,'/BetaBurstGA/HMM/'));
fileName = '../config.json'; % filename in JSON extension
str = fileread(fileName); % dedicated for reading files as text
data = jsondecode(str); 


load ../datafiles/PopCurrent.mat

sizePop = data.GA_config.size_pop;
sampling_freq=data.solve_options.sampling_rate;
numTrials = data.solve_options.mc_trials;


hmmstats  = zeros(4,2,sizePop); % rows, 3 coloumns .....
hmmstats(:) = NaN;

save('../datafiles/stats.mat', 'hmmstats')

disp('Running HMM on all phenotypes in this generation')
failcount = 0;
T = 0;
for i = 1:sizePop

    fprintf('Running HMM on phenotype %d \n',i)
    stats = hmm_burst_detect_and_stats(squeeze(popcurrent(:,:,i)),numTrials,sampling_freq)

    hmmstats(:,:,i) = stats
end



stats = hmmstats;

save('../datafiles/HMMStats.mat', 'stats')


    
