
function [odes] = hopf_learn(t,x,m,e, F,F_t)

% An Adaptive-Frequency Hopf Oscillator
%
% Dynamic Hebbian learning in adaptive frequency oscillators, Righetti, Buchli, and Ijspeert, 2006
% Implemented by Parker Tichko, 2022
%
% W = Hebbian learning of oscillator frequency
% m = parameter for oscillator amplitude, m > 0
% e = parameter for learning rate, e > 0
% F = input, often periodic forcing (e.g., sin(t), cos(t))
% F_t = discrete time of F
%
% System is 3 odes expressed in Cartesian coordinates
% X = hopf oscillator
% Y = hopf oscillator
% W = hebbian learning rule

% % Example: Recreate Figure 2 in  Righetti, Buchli, and Ijspeert, 2006
% % start/stop simulation
% t0 = 0;
% tend = 3000;
% Fs = 120; 
% 
% % periodic forcing (cosine input)
% F_t = linspace(t0, tend, tend*Fs);
% F = cos(30*F_t);
% plot(F)
% 
% % model parameters
% m = 1;                  % osc amplitude
% e = [1 ;0.8; 0.6; 0.4]; % learning rates from fig 2.
% tspan = [t0 tend];      % full timespan
% %tspan = [cos_t];       % time points for cos
% 
% % integration 
% for i = 1:length(e)
% [t, y] = ode45(@(t,x)hopf_learn(t,x, m, e(i), F, F_t)...
%     ,tspan, [0, 1, 40] );
%     plot(t,y(:,3), 'black');
%     hold on
% end
% 
% title('Adaptive-Frequency Hopf Oscillator with Hebbian Learning')
% xlabel('Time')
% ylabel('W (Angular Frequency)')
% legend(num2str(e))
% hold off;

F = interp1(F_t, F, t);

X = x(1);
Y = x(2);
W = x(3);

dXdt = (m-(sqrt(X^2+Y^2))^2)*X-W*Y+e*F;
dYdt = (m-(sqrt(X^2+Y^2))^2)*Y+W*X;
dWdt = -e*F*(Y/sqrt(X^2+Y^2));

odes = [dXdt; dYdt; dWdt];
