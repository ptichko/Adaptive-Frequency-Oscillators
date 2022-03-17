
function [odes] = rayleigh_learn(t,x,d,q,e,F,F_t)

% An Adaptive-Frequency Rayleigh Oscillator
%
% Dynamic Hebbian learning in adaptive frequency oscillators, Righetti, Buchli, and Ijspeert, 2006
% Implemented by Parker Tichko, 2022
%
% W = Hebbian learning of oscillator frequency
% d = parameter for osc
% q = paramter for osc
% e = parameter for learning rate, e > 0
% F = input, often periodic forcing (e.g., sin(t), cos(t))
% F_t = discrete time of F
%
% System is 3 odes expressed in Cartesian coordinates
% X = oscillator
% Y = oscillator
% W = hebbian learning rule

% %% Figure 10 from Righetti, Buchli, and Ijspeert, (2006)
% % start/stop simulation
% t0 = 0;                 % start time
% tend = 200;            % stop time
% 
% % periodic forcing (cosine input)
% Fs = 120;               % sample rate of periodic forcing
% F_t = linspace(t0, tend, tend*Fs); %dt for periodic forcing
% F = sin(20*F_t);        
% plot(F); ylim([-1.5 1.5]);
% 
% % model parameters
% d = 50;                 
% q = 1;
% e = 0.3;               % learning rate
% w0 = [20];         % initial conditions for osc freq
% %tspan = [t0 tend];     % full timespan
% tspan = F_t;
% 
% for i = 1:length(w0)
% [t, y] = ode23(@(t,x)rayleigh_learn(t,x,d,q,e,F,F_t)...
%     ,tspan, [0, 1, w0(i)] );
% end
% 
% fig = figure;
% set(fig,'defaultAxesColorOrder',[[0.4940 0.1840 0.5560];	[0 0 0]]);
% 
% subplot(3,1,1)
% plot(t,y(:,3), 'black');
% ylabel('W (Angular Frequency)')
% title('Adaptive-Frequency Rayleigh Oscillator')
% 
% hold on
% subplot(3,1,2)
% yyaxis right;
% plot(t,F, '--black', 'LineWidth', 1.5);
% ylim([-4 4]);
% ylabel('F')
% yyaxis left;
% plot(t,y(:,1), 'LineWidth', 2, 'Color', '#7E2F8E');
% ylim([-0.1 0.1]);
% xlim([0 2]);
% ylabel('X')
% hold off;
% 
% hold on;
% subplot(3,1,3)
% yyaxis right;
% plot(t,F, '--black', 'LineWidth', 1.5);
% ylim([-4 4]);
% ylabel('F')
% yyaxis left;
% plot(t,y(:,1), 'LineWidth', 2, 'Color', '#7E2F8E');
% ylim([-0.1 0.1]);
% xlim([198 200]);
% xlabel('Time')
% ylabel('X')
% %legend('F', 'Oscillator');


F = interp1(F_t, F, t);

X = x(1);
Y = x(2);
W = x(3);

dXdt = Y+e*F;
dYdt = d*(1-q*Y^2)*Y-(W^2)*X;
dWdt = e*F*(Y/sqrt(X^2+Y^2));

odes = [dXdt; dYdt; dWdt];
