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

% Manual changing of the start and end time. This can be set manually in case one wants to filter the beginning and end bits. Set to any value <0 in case you want to use the full scan.
T1 = -1; % start time in hours. 
T2 = 80; % end time in hours

% calculate the starting and end indices
i = T1*3600*rate;
j = T2*3600*rate;

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
PDdata = rawData(:,2);

% calculate the tau array (equally log spaced)
%q=(T/2)^(1/(n-1));
%tau = 1/rate*q.^[0:1:n-1];

tau=[10.^[-2:1:1]*3600, 24*3600];

%% Temperature sweeps
%% Keep commented out

%% create exponential fit. 
% WDM2 II
%T1= 0.169; % Starttime in hours
%T2= 0.21; % End time in hours

% WDM2 IV
%T1 = 0.22;
%T2 = 0.26

% WDM2 III
%T1 = 0.33;
%T2 = 0.38;

% WDM2 V
%T1 = 0.4;
%T2 = 0.475;

% % WDM1 IV
% T1 = 0.3;
% T2 = 0.42;
% 
% % WDM1 V
% T1 = 0.4533;
% T2 = 0.5319;
% 
% % WDM1 VI
% T1 = 0.557;
% T2 = 0.676;
% 
% % WDM1 VII
% T1=0.694;
% T2 = 0.7853;
% 
% % PBS I
% T1 = 0.1306;
% T2= 0.2367;
% 
% % PBS II
% T1 = 0.2922;
% T2= 0.5;

% convert time to indices
%i = T1*rate*3600;
%j = T2*rate*3600;

%i=1;%252000;
%j=size(rawData(:,1))/2;

%cropped_freq = rawData(i:j,2);
%cropped_time = rawData(i:j,1);
%cropped_temp = rawData(i:j,5);

%% feature scaling
%cropped_freq = featureScale(cropped_freq);
%cropped_temp = featureScale(cropped_temp);

% T0 = 40;
% init_guess = [mean(cropped_freq) T0 mean(cropped_freq) cropped_time(1)];
% fitresult = expFit2(cropped_time,cropped_freq, init_guess);
% figure(4)
% clf()
% hold on;
% plot(fitresult, cropped_time, cropped_freq);
% plot(cropped_time,cropped_freq);
% hold off;
% disp(['time constant: ', num2str(fitresult.b),'s'])
% 

% %% calculate delay between temperature and system response
% 
% figure(10)
% [r, lags] = xcorr(cropped_temp,cropped_freq);
% plot(lags,r)
% 
% temperature_lag = lags(find(r==max(r)));
% 
% disp('system inertia w.r.t. temperature (s): ')
% disp(num2str(temperature_lag))
% 
% figure(11)
% clf()
% hold on;
% plot(cropped_time/3600,cropped_freq)
% plot(cropped_time/3600,cropped_temp)
% hold off;
% 
% figure(12)
% clf()
% hold on;
% plot(cropped_time/3600,cropped_temp)
% plot((cropped_time+lags(find(r==max(r))))/3600,cropped_freq)
% hold off;



%% calculate and plot the ADEV.

name0 = 'Photodiode';
% construct the object (including time-stamp zeroing)
data0 = struct('freq', PDdata, 'time',t,'rate',rate, 'average',mean(PDdata));

% name1 = 'Temperature 1';
% data1 = struct('freq', rawData(i:j,3), 'time',rawData(i:j,1),'rate',rate);
% 
% name2 = 'Temperature 2';
% data2 = struct('freq', rawData(i:j,4), 'time',rawData(i:j,1),'rate',rate);
% 
% name3= 'Temperature 3';
% data3 = struct('freq', rawData(i:j,5), 'time',rawData(i:j,1),'rate',rate);
% 
% name4 = 'Temperature 4';
% data4 = struct('freq', rawData(i:j,6), 'time',rawData(i:j,1),'rate',rate);
% 
% name5 = 'Temperature 5';
% data5 = struct('freq', rawData(i:j,7), 'time',rawData(i:j,1),'rate',rate);

%dataSet = [data1,data2,data3,data4,data5];
%dataSet = [data0,data3];
dataSet = [data0];
%legendSet = cell(5,1);
legendSet = cell(1,1);
legendSet{1} = name0;
% legendSet{2} = name1;
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
    [ADEVdata] = plotADEV_multiple(dataSet(i),avar, titleName, store, colorSet(i*5,:), true);   
end

plots=2;
for i=1:plots
    figure(i)
    legend(legendSet, 'location', 'best')
end


% display some values
ADCbit = 2^24;
disp('ADC span ratio [%]:')
format short
disp(round(data0.average/ADCbit*100))

% range = 117/ADCGain;
% current = mean(rawData(:,2))/ADCmax*range;
% disp('mean photocurrent (nA) :')
% disp(round(current))
% 
% disp('measured optical power (nW) :')
% disp(round(current/spectralSens))

if store==true
    
    % save the figures
    h = figure(1);
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(h,'norm_Power','-dpdf','-r0')
    savefig('norm_Power.fig');
    
    h = figure(2);
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(h,'logADEV','-dpdf','-r0')
    savefig('logADEV.fig');
         
%     h=figure(3);
%     set(h,'Units','Inches');
%     pos = get(h,'Position');
%     set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
%     print(h,'linADEV','-dpdf','-r0')
%     savefig('linADEV.fig');
  
   
    %write the data into the file
    fileID = fopen('ADEV.txt','w');
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



