% This script analyses time series measurements taken at constant intervals
% from one or more photodiodes. It calculates and plots the normalized Allan
% deviation
% Author: Philippe Raisin
% University of Bern, Institute of applied physics
% email: philippe.raisin@iap.unibe.ch
% Website: http://www.iapla.unibe.ch
% Feb 2017; Last revision: 28-Feb-2017

%------------- BEGIN CODE --------------

%% close all plots and clear the workspace
close all;
%clc;


%% let the user choose the path and set the parameters

n = 40; % number of points in the ADEV plot
ADCGain = 1; 
%spectralSens = 0.6; %A/W
rate = 1;  % in Hz
store = true;
titleName = '';

T1 = -1; % start time in hours
T2 = -1; % end time in hours

% calculate the starting and end indices
i = T1*3600/rate;
j = T2*3600/rate;

if T1<0
    i = 1;
end

if T2<0
    j = N;
end


%% ask user to insert path and load file and read data
[filename,path]= uigetfile({'*.csv'},'File Selector');
%excelpath = uigetfile({'*.xlsm'},'File Selector');
cd(path);
rawData=dlmread(filename);
N = size(rawData,1);

% crop it
rawData = rawData(i:j,:);

% read out the data from the columns (normalize the time-stamps)
t = rawData(:,1)-rawData(1,1);
T = t(end)-t(1);


% calculate the tau array (equally log spaced)
q=(T/2)^(1/(n-1));
tau = 1/rate*q.^[0:1:n-1];

%% calculate and plot the ADEV

name0 = 'Temperature 1';
% construct the object (including time-stamp zeroing)
data0 = struct('freq', rawData(:,4), 'time',t,'rate',rate, 'average',mean(rawData(:,4)));

%name1 = 'Temperature 2';
%data1 = struct('freq', rawData(:,5), 'time',t,'rate',rate, 'average',mean(rawData(:,4)));
 
% name2 = 'Temperature 3';
% data2 = struct('freq', rawData(:,5), 'time',t,'rate',rate, 'average',mean(rawData(:,5)));
%  
% name3= 'Temperature 4';
% data3 = struct('freq', rawData(:,6), 'time',t,'rate',rate, 'average',mean(rawData(:,6)));
% 
% name4= 'Temperature 5';
% data4 = struct('freq', rawData(:,7), 'time',t,'rate',rate, 'average',mean(rawData(:,7)));


% name4 = 'Temperature 4';
% data4 = struct('freq', rawData(i:j,6), 'time',rawData(i:j,1),'rate',rate);
% 
% name5 = 'Temperature 5';
% data5 = struct('freq', rawData(i:j,7), 'time',rawData(i:j,1),'rate',rate);

%dataSet = [data1,data2,data3,data4,data5];
%dataSet = [data0,data3];
dataSet = [data0]%, data1];%,data2, data3,data4];
%legendSet = cell(5,1);
legendSet = cell(1,1);
legendSet{1} = name0;
%legendSet{2} = name1;
% legendSet{3} = name2;
% legendSet{4} = name3;
% legendSet{5} = name4;

avarSet=[];
colorSet = varycolor(numel(dataSet)*10);

% iterate through the data set
for i=1:numel(dataSet)    
    
    % calculate the ADEV
    avar=allan(dataSet(i),tau,n);
    
    % plot the ADEV 
    [ADEVdata] = plotADEVmultipleTemp(dataSet(i),avar, titleName, store, colorSet(i*5,:), false);   
end

plots=2;
for i=1:plots
    figure(i)
    legend(legendSet, 'location', 'best')
end


if store==true
    
    % save the figures
    h = figure(1);
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(h,'temp','-dpdf','-r0')
    savefig('temp.fig');
    
    h = figure(2);
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(h,'logADEVtemp','-dpdf','-r0')
    savefig('logADEVtemp.fig');
    
%     
%     h=figure(3);
%     set(h,'Units','Inches');
%     pos = get(h,'Position');
%     set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
%     print(h,'linADEV','-dpdf','-r0')
%     savefig('linADEV.fig');
%     
   
    %write the data into the file
    fileID = fopen('ADEVtemp.txt','w');
    fprintf(fileID, '%.8f, %.8f, %.8f\n', ADEVdata);
    
    
end

return


%% do the fft
freq=data0.time;
S = data0.freq;

N = numel(S);

%sampling frequency (points per Hz)
domega = abs((freq(1)-freq(end))/N);


fa = 1/domega; % inverse of frequency step gives sample points per Hertz.
fn = fa/2; % Nyquist-frequency (max. frequency)
df = fa/N; % Frequency resolution

% calc. FFT  and normalize (absolute value, no phase)
G = abs(fft(S)./N); 

% normalize the second-order correlation function
G = G/max(G);



% go to single-sided
G = G(1:N/2);
G(2:N/2) = 2*G(2:N/2);
% 
% % create the x-values
%x_fn = -(fn-df) : df : fn;
 x_fn = 0:df:fn-df;

% display and plot

figure(4);
clf(4);
%G=10*log10(G(1:20))
%x_fn = 10*log10(x_fn(1:20))
hold on;
plot(x_fn,10*log10(G))
set(gca,'YScale','linear', 'XScale','linear') 
    grid on;
    box on;
title 'FFT'
xlabel 'Frequency [Hz]'
ylabel '\Gamma(t)'
%xlim([-1,1])



