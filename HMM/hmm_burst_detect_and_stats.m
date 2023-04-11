function stats = hmm_burst_detect_and_stats(current,numTrials,sampling_freq)
stats = zeros(4,2);
%% Run HMM_TE on each subject and region individually
for sub = 1:1
    
   
    
    % Get 1-48 Hz filtered VE timecourse
    
    % In our case, the VE matrix is (78 brain regions x length of dataset)
    T = size(current,2);
    %current = current';
    samp_freq = sampling_freq; % sampling frequency, Hz
    % Downsample from 500 to 100Hz
    new_freq = 100;
    [data_new,T_new] = downsampledata(current',T,new_freq,samp_freq);
    
    % Hack to allow some temporally local variance normalisation
    dummy_trial_length = 4; % secs
    dummy_trial_length = dummy_trial_length*100; % in num of samples
    T_cat = ones(ceil(size(data_new,1)/dummy_trial_length),1)*dummy_trial_length; 
    tmp = rem(size(data_new,1),dummy_trial_length);
    if tmp > 0
        T_cat(end) = tmp;
    end
    T_new = T_cat;
    data_new = data_new';
    
    % Set the HMM Options
    Hz = 100; % the frequency of the downsampled data
    lags = 11; % sensible to range between 3 and 11.
    no_states = 3;
    options = struct(); % Create options struct
    options.K = no_states;
    options.standardise = 1;
    options.verbose = 1;
    options.Fs = Hz;
    options.order = 0;
    options.embeddedlags = -lags:lags; 
    options.zeromean = 1;
    options.covtype = 'full'; 
    options.useMEX = 1; % runs much faster with the compiled mex files
    options.dropstates = 1; % the HMM can drop states if there isn't sufficient evidence to justify this number of states.
    options.DirichletDiag = 10; % diagonal of prior of trans-prob matrix (default 10 anyway)
    options.useParallel = 0;

    % HMM computation, one region at a time
    for reg = 1:numTrials % 78 AAL Atlas locations
        disp(['Calculating HMM output for subject ',num2str(sub), ', region ',num2str(reg)])
        VEf_b_reg = data_new(reg,:); % single channel data
        data_reg = normalize(VEf_b_reg'); % normalise!!
        [hmm, Gamma] = hmmmar(data_reg,T_new,options); % hmm inference
        hmm_all_reg{reg} = hmm;
        Gamma_all_reg{reg} = Gamma;
    end
    
    % Save the output
 
    save hmm_all_reg.mat
    save Gamma_all_reg.mat
end
%% HMM Options:
options = struct(); % Create options struct
no_states = 3;
Hz = 100; % the frequency of the downsampled data
options.K = no_states;
options.standardise = 1; % since we hacked the T vector
options.verbose = 1;
options.Fs = Hz;
options.order = 0;
lags = 11; % a sensible range is between 3 and 11.
options.embeddedlags = -lags:lags; 
options.zeromean = 1;
options.covtype = 'full'; 
options.useMEX = 1; % runs much faster
options.dropstates = 1;
options.DirichletDiag = 10; % diagonal of prior of trans-prob matrix (default 10 anyway)
options.useParallel = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load data:
for sub = 1
 
    
   
    T = size(current,2);
    [data_new,T_new] = downsampledata(current',T,100,samp_freq);

    % Hack to allow some temporally local variance normalisation
    dummy_trial_length = 4; % secs
    dummy_trial_length = dummy_trial_length*100; % in num of samples
    T_cat = ones(ceil(size(data_new,1)/dummy_trial_length),1)*dummy_trial_length; 
    tmp = rem(size(data_new,1),dummy_trial_length);
    if tmp > 0
        T_cat(end) = tmp;
    end
    T_new = T_cat;
    data_new = data_new';
    
    load hmm_all_reg.mat
    hmm_all_reg_TE = hmm_all_reg;
    load Gamma_all_reg.mat 
    Gamma_all_reg_TE = Gamma_all_reg;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Classify burst state
    for reg = 1:numTrials % 78 AAL regions 
        VE_reg = data_new(reg,:); % single channel data
        data_reg = normalize(VE_reg');

        % Correct Gamma time-course for lags in AR model
        Gamma_reg = Gamma_all_reg_TE{reg};
        Gamma_reg = padGamma(Gamma_reg,T_new,options);
        
        % 13-30Hz data:
        [wt,wf] = cwt(data_reg,'amor',100); % morlet wavelet
        beta_wavelet_freqs = wf > 13 & wf < 30;
        % Envelope of beta oscillations
        HVEf_b_reg = mean(abs(wt(beta_wavelet_freqs,:)),1)';
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Correlation of burst probability timecourse with beta envelope
        corr_tmp = [];
        for k = 1:size(Gamma_reg,2)
            corr_tmp(k) = corr(Gamma_reg(:,k),HVEf_b_reg);
        end

        [a burst_state] = max(corr_tmp);
        corr_vals(sub,reg) = max(corr_tmp);

        % Classify bursts using thresholded gamma:
        gamma_thresh = 2/3;
        burst_mask_gamma(reg,:) = Gamma_reg(:,burst_state)>gamma_thresh;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Burst duration
        % Burst lifetimes
        LTs_hmmar = getStateLifeTimes(Gamma_reg,size(Gamma_reg,1),options,0,gamma_thresh);
        burst_LTs = LTs_hmmar{burst_state};
        burst_dur(sub,reg) = mean(burst_LTs)*1000/options.Fs; % milliseconds

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
%% Number of bursts
        num_bursts(sub,reg) = length(burst_LTs)/(size(Gamma_reg,1)/options.Fs);
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Burst amplitude
        burst_envelope = HVEf_b_reg'.*burst_mask_gamma(reg,:);
        burst_starts = find(diff(burst_mask_gamma(reg,:)) == 1);
        burst_ends = find(diff(burst_mask_gamma(reg,:)) == -1);
        if burst_starts(1) > burst_ends(1)
            burst_ends(1) = [];
        end
        if burst_starts(end) > burst_ends(end)
            burst_starts(end) = [];
        end
        clear burst_max
        for b = 1:length(burst_starts)
            burst_max(b) = max(burst_envelope(burst_starts(b):burst_ends(b)));
        end
        burst_pow(sub,reg) = mean(burst_max);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Time between bursts
        state_ITs = getStateIntervalTimes(Gamma_reg,size(Gamma_reg,1),options,0,gamma_thresh);
        burst_ITs = state_ITs{burst_state};
        burst_ISL(sub,reg) = mean(burst_ITs)*1000/options.Fs; % milliseconds
    end
end

stats(1,1) = mean(burst_dur);
stats(2,1) = std(burst_dur);
stats(3,1) = skewness(burst_dur);
stats(4,1) = kurtosis(burst_dur);



stats(1,2) = mean(num_bursts);
stats(2,2) = std(num_bursts);
stats(3,2) = skewness(num_bursts);
stats(4,2) = kurtosis(num_bursts);




end



