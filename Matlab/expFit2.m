function [fitresult] = expFit2(t, y, initGuess)

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
fitresult = fit( t, y, ft, opts );
end
