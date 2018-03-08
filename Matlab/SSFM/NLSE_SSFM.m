N      = 512;                   % Number of fourier steps
dt     = .001;                  % Time step
tfinal = 10;                    % Final time
M      = round(tfinal./dt);     % Total number of time steps
J      = 100;                   % Steps between output
L      = 50;                    % Space period
h      = L/N;                   % Space step
n      =( -N/2:1:N/2-1)';       % Indices
x      = n*h;                   % Grid points
u      = exp(1i*x).*sech(x);    %Intial condition
k      = 2*n*pi/L;              % Wavenumbers.

figure(1)
clf();

for m = 1:1:M  % Start time loop
u  = exp(dt*1i*(abs(u).*abs(u))).*u;
c  = fftshift(fft(u));
c = exp(-dt*1i*k.*k/2).*c;
u = ifft(fftshift(c));
plot(u)
pause
m
% Solve non-linear part of NLSE
% Take Fourier transform
% Advance in Fourier space
% Return to Physical Spacee
end
