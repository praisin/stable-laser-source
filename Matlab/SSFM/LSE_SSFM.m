N      = 11;
dt     = .005;
tfinal = 2;
M      = round(tfinal/dt);  % Total number of time steps
J = 100; L = 20; q = -1; mu = 2/3; v =1;
h= L/N;
n= (-N/2:1:N/2-1)';
x= n*h;
% Steps between output
% Space period
% Space step
% Indices
% Grid points
u0 = (12 - 48*x.^2 + 16*x.^4)./...
     (8.*sqrt(6).*exp(x.*x/2.)*pi.^0.25);
u= u0;
k= 2*n.*pi/L; t = 0;
figure(1)
clf()
for m = 1:1:M
% Initial Condition
% Wavenumbers.
% Start time loop
% Number of Fourier modes
% Size of time step
% Final time
u = exp(dt/2*1j*q*x.^2).*u; % Solve non-constant part of LSE c= fftshift(fft(u)); % Take Fourier transform
c = exp(dt/2*1j*-k.^2); % Advance in Fourier Space
u= ifft(fftshift(c)); % Return to Physical Space

plot(abs(u));
pause;
m
end