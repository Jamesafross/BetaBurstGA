
clear all; close all;
parpool('Processes',5)
homedir=getuserdir();
addpath(genpath(append(homedir,'/HMM-MAR/')))
addpath(genpath(append(homedir,'/nutmeg/')))

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
parfor i = 1:sizePop

    fprintf('Running HMM on phenotype %d \n',i)

    hmmstats(:,:,i) = supress_gather_output(i,popcurrent,numTrials,sampling_freq);
end



stats = hmmstats;

save('../datafiles/HMMStats.mat', 'stats')


function stats = supress_gather_output(i,popcurrent,numTrials,sampling_freq)
    try
        [T,stats] = evalc('hmm_burst_detect_and_stats(squeeze(popcurrent(:,:,i)),numTrials,sampling_freq);');
    catch
        stats = zeros(4,2);
        stats(:) = NaN;
    end
end
