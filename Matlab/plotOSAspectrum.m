

%% read data

% both diode spliced to PBS
% left spectrum: 811007 (I=341mA), right spectrum: 811009
%filename ='/Users/Philippe/Desktop/IAP/PRJ intrinsically stable source/labdata/Ytterbium/ISS-Yb005/initial active fiber splicing/spectra/Yb198 fifth pump after sleeve with active pump.csv';



% Diode 811007 freerun (341mA)
filename='/Users/Philippe/Desktop/IAP/PRJ intrinsically stable source/labdata/Ytterbium/915nm Diodes/2016-07-09 Integration sphere/Diode 811007/Integrating sphere/Scan15/Spectra/RawData/W0000.csv';
[lambda1,S1] =loadOSASpectrum(filename);
S1 = S1./max(S1);

% Diode 811009 (I=312mA)
filename = '/Users/Philippe/Desktop/IAP/PRJ intrinsically stable source/labdata/Ytterbium/915nm Diodes/2016-07-09 Integration sphere/Diode 811009/Integrating sphere/Scan1/spectra/W0001.csv';
[lambda2,S2] =loadOSASpectrum(filename);
S2 = S2./max(S2);


% Diode 811007 after PBS
filename ='/Users/Philippe/Desktop/IAP/PRJ intrinsically stable source/labdata/Ytterbium/915nm Diodes/2016-08-19 Integration sphere/Scan2/spectra raw/811007.csv';
[lambda3,S3] =loadOSASpectrum(filename);
S3 = S3./max(S3);

% Diode 811009 after PBS
filename ='/Users/Philippe/Desktop/IAP/PRJ intrinsically stable source/labdata/Ytterbium/915nm Diodes/2016-08-19 Integration sphere/Scan2/spectra raw/811009.csv';
[lambda4,S4] =loadOSASpectrum(filename);
S4 = S4./max(S4);


%% display and plot

createPlot(lambda1,S1,lambda2,S2,lambda3,S3,lambda4,S4)



