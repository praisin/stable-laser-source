function [avar]=normADEV(data, n)

% Compute the normalized Allan deviation for a constant-rate time series
% [ADEV]=allan(DATA, TAU) 
%
% INPUTS:
%  DATA should be a struct and has the following fields: 
%  DATA.freq    the time series measurements in arb. units
%  DATA.time    the timestamps of the measurement
%  DATA.rate    constant rate of time series in (Hz)
%               (Differently from previous versions of allan.m,
%               it is not possible to compute variances for time-
%               stamp data anymore.)
%  n            number of points in the allan plot (size(tau,1))
%  name         sample name, will be displayed in the plots
%  TAU is an array of the tau values for computing Allan deviations
%
% OUTPUTS: 
% AVAR is a struct and has the following fields (for values of tau):
%  AVAR.sig     = standard deviation
%  AVAR.sig2    = Allan deviation
%  AVAR.sig2err = standard error of Allan deviation
%  AVAR.osig    = Allan deviation with overlapping estimate
%  AVAR.osigerr = standard error of overlapping Allan deviation
%  AVAR.msig    = modified Allan deviation 
%  AVAR.msigerr = standard error of modified Allan deviation
%  AVAR.tsig    = timed Allan deviation
%  AVAR.tsigerr = standard error of timed Allan deviation
%  AVAR.tau1    = measurement interval in (s)
%  AVAR.tauerr  = errors in tau that might occur because of initial
%  rounding

%% first calculate the tau-array
tau=gettau(data,n);

% set the first time stamp to be T=0
data.time = data.time-data.time(1);

%% normalize the data values
% commented out on 1.7.2016 by P. Raisin: The normalization is only done
% when plotting, up to there it's all done in absolute measures.
%normdata=data; % copy the data struct to normdat
% normalize by dividing by the mean of the data
%normdata.freq = (normdata.freq-mean(normdata.freq))/std(normdata.freq);%mean(normdata.freq); 

%% calculate the allan deviation and return
avar=allan(data, tau);


end

