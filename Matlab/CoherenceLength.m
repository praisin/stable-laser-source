%% 2016-07-08 Fusion fs Spectrum and ACF calculation from spectrum

% This script calculates the Second-order coherence function Gamma (G) via the
% Wigner-Kinchin Theorem, stating that G = FT(S) holds, where S is the
% PSD (Power spectral density), meaning the values we measure with the
% spectrometer. From G it should be possible to estimate the coherence
% length of the source.

%% read data
filename='/Users/Philippe/Desktop/IAP/PRJ intrinsically stable source/labdata and figures/Ytterbium-Setup/915nm Diodes/2016-07-09 Integration sphere/Diode 513008 spectrum/Scan1/spectra/W0001.csv';
[lambda,S] =loadSpectrum(filename);

% rescale wavelength from [nm] to [m]
lambda = lambda*10^-9;
lambda_c = 915*10^-9;

%% cut and rescale the spectrum
%i=210;
%j=3001;
%S = S(i:j);
%lambda=lambda(i:j);

c=299792458; 
% rescale wavelength to frequency
freq  = c./lambda;
df = (freq(end)-freq(1))/numel(freq);
% rescale power density
S = S*c./lambda.^2;
freq0 = c/lambda_c;
omega0 = freq0*2*pi;

%% FFT
% pad the array left and right
N_unpadded = 100*numel(S);
S_padded = padarray(S,[N_unpadded-1,0],'both');
f_min = freq(1)-N_unpadded*df;
f_max = freq(end)+N_unpadded*df;
freq_1= linspace(f_min,freq(1),N_unpadded);
freq_2= freq(2:end-1).';
freq_3= linspace(freq(end),f_max,N_unpadded);
freq_padded = [freq_1,freq_2,freq_3 ].';

S=S_padded;
freq = freq_padded;
N = numel(S);

%sampling frequency (points per Hz)
domega = (freq(1)-freq(end))/N;


fa = 1/domega; % inverse of frequency step gives sample points per Hertz.
fn = fa/2; % Nyquist-frequency
df = fa/N; % Frequency resolution

% calc. FFT (absolute value, no phase)
G = abs(fftshift(fft(fftshift(S)))); 

% normalize the second-order correlation function
G = G/max(G);



% go to single-sided
%E_t_abs = E_t_abs(1:N/2);
%E_t_abs(2:N/2) = 2*E_t_abs(2:N/2);

% create the x-values
x_fn = -(fn-df) : df : fn;

% calculate the integral of the first-order correlation function
l_coh = trapz(x_fn,G.^2)*c*10^3;




%% display and plot

disp('coherence length: ')
disp([num2str(l_coh),'mm'])


figure(1);
plot((2*pi*freq-omega0)/10^15, S, 'b.-') 
title 'Spectrum'
ylabel 'S(\Omega)^2'
xlabel 'Frequency \Omega [Rad/fs]'
%xlim([-.05,0.05])


figure(2);
clf();
plot(x_fn*10^9, G, 'b.-') 
title 'FFT'
xlabel 'Time [ns]'
ylabel '\Gamma(t)'
%xlim([-1,1])


figure(3)
clf();
plot(x_fn*c*100, G, 'b.-') 
title 'FFT'
xlabel 'length [cm]'
ylabel '\Gamma(l)'
%xlim([-350,350])

