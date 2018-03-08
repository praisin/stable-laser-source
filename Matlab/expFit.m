function [fitresult, gof] = expFit(t, y, initGuess)

%% Initialization.


%% Fit: 'WDM2 I'.
[xData, yData] = prepareCurveData( t, y );

% Set up fittype and options.
ft = fittype( 'a*exp(-(x-d)/b)+c', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Algorithm = 'Levenberg-Marquardt';
opts.DiffMaxChange = 0.01;
opts.DiffMinChange = 1e-09;
opts.Display = 'Off';
opts.MaxFunEvals = 1000;
opts.MaxIter = 1000;
opts.Robust = 'Bisquare';
opts.StartPoint = initGuess;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'WDM2 I' );
h = plot( fitresult, xData, yData );
legend( h, 'y vs. t', 'WDM2 I', 'Location', 'NorthEast' );
% Label axes
xlabel t
ylabel y
grid on

end

