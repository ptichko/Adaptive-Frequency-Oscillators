%% Figure 8 from Righetti, Buchli, and Ijspeert, (2006)
% start/stop simulation
t0 = 0;                 % start time
tend = 1000;            % stop time

% input signal
Fs = 120;                           % sample rate of periodic forcing
F_t = linspace(t0, tend, tend*Fs);  % dt for periodic forcing
F = sin(30*F_t);        
plot(F); ylim([-1.5 1.5]);

% model parameters
a = 50;                 % osc non-linearity
e = 0.7;                % learning rates from fig 8.
% tspan = [t0 tend];    % full timespan
tspan = F_t;
w0 = [24; 28];         % initial conditions for osc freq

for i = 1:length(w0)
[t, y] = ode23(@(t,x)vanderpol_learn(t,x, a, e, F, F_t)...
    ,tspan, [0, 1, w0(i)] );
    plot(t,y(:,3), 'black');
    hold on
end

%% Figure 9 from Righetti, Buchli, and Ijspeert, (2006)
% start/stop simulation
t0 = 0;                % start time
tend = 800;            % stop time

% input signal
Fs = 120;                          % sample rate
F_t = linspace(t0, tend, tend*Fs); % dt for input signal
F = sin(40*F_t);        
plot(F); ylim([-1.5 1.5]);

% model parameters
a = 100;                % osc non-linearity
e = 0.7;                % learning rates from fig 9.
% tspan = [t0 tend];    % full timespan
tspan = F_t;
w0 = [40];              % initial conditions for osc freq

for i = 1:length(w0)
[t, y] = ode23(@(t,x)vanderpol_learn(t,x, a, e, F, F_t)...
    ,tspan, [1, 1, w0(i)] );
end

fig = figure;
set(fig,'defaultAxesColorOrder',[[0.4940 0.1840 0.5560];	[0 0 0]]);

subplot(3,1,1)
plot(t,y(:,3), 'black');
ylim([35 55]);
ylabel('W (Angular Frequency)')
title('Adaptive-Frequency Van der Pol Oscillator')

hold on
subplot(3,1,2)
yyaxis right;
plot(t,F, '--black', 'LineWidth', 1.5);
ylim([-2.2 2.2]);
ylabel('F')
yyaxis left;
plot(t,y(:,1), 'LineWidth', 2, 'Color', '#7E2F8E');
ylim([-2.2 2.2]);
xlim([0 1]);
ylabel('X')
hold off;

hold on;
subplot(3,1,3)
yyaxis right;
plot(t,F, '--black', 'LineWidth', 1.5);
ylim([-2.2 2.2]);
ylabel('F')
yyaxis left;
plot(t,y(:,1), 'LineWidth', 2, 'Color', '#7E2F8E');
ylim([-2.2 2.2]);
xlim([799 800]);
xlabel('Time')
ylabel('X')
%legend('F', 'Oscillator');

      