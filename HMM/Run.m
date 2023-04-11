
clear all; close all;
parpool('Processes',10)

addpath(genpath('/home/james/HMM-MAR-master/'))
addpath(genpath('/home/james/nutmegbeta/'))

load ../datafiles/PopCurrent.mat

sizePop = size(popcurrent,3);
hmmstats  = zeros(4,2,sizePop); % rows, 3 coloumns .....
hmmstats(:) = NaN;
sampling_freq=100;
numTrials = size(popcurrent,1);
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