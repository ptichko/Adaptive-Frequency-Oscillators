%% Figure 10 from Righetti, Buchli, and Ijspeert, (2006)
% start/stop simulation
t0 = 0;                % start time
tend = 500;            % stop time

% input signal
Fs = 120;               % sample rate of periodic forcing
F_t = linspace(t0, tend, tend*Fs); %dt for periodic forcing
F = sin(20*F_t);        
plot(F); ylim([-1.5 1.5]);

% model parameters
a = 0.15;                 
b = 0.1;
c = 8.5;
e = 4;               % learning rate
w0 = [30];           % initial conditions for osc freq
%tspan = [t0 tend];  % full timespan
tspan = F_t;

for i = 1:length(w0)
[t, y] = ode23(@(t,x)rossler_learn(t,x,a,b,c,e,F,F_t)...
    ,tspan, [1, 0, 0, w0(i)] ); % unsure what inititial conditions for x,y,z are in Righetti et al. (2006)
end

fig = figure;
set(fig,'defaultAxesColorOrder',[[0.4940 0.1840 0.5560];	[0 0 0]]);

subplot(3,1,1)
plot(t,y(:,4), 'black');
xlim([t0 tend])
ylim([10 32]);
ylabel('W (Angular Frequency)')
title('Adaptive-Frequency Rossler Strange Attractor')

hold on
subplot(3,1,2)
yyaxis right;
plot(t,F, '--black', 'LineWidth', 1.5);
ylim([-2 2]);
ylabel('F')
yyaxis left;
plot(t,y(:,1), 'LineWidth', 2, 'Color', '#7E2F8E');
ylim([-2 2]);
xlim([0 2]);
ylabel('X')
hold off;

hold on;
subplot(3,1,3)
yyaxis right;
plot(t,F, '--black', 'LineWidth', 1.5);
ylim([-2 2]);
ylabel('F')
yyaxis left;
plot(t,y(:,1), 'LineWidth', 2, 'Color', '#7E2F8E');
ylim([-200 200]);
xlim([498 500]);
xlabel('Time')
ylabel('X')
% legend('F', 'Oscillator');

  
%% Draw Animation
fig2 = figure;
fig2.Position = [823   264   417   714];
subplot(3,1,1)
plot3(0,0,0,'-', 'MarkerSize', 20, 'Color', '#7E2F8E')          % hack to initialize 3d for animation
phasesp_1a = animatedline('Color','#808080', 'LineWidth', 0.25);
phasesp_1b = animatedline('Marker','.', 'MarkerSize', 20, 'Color', '#7E2F8E');
xlim([-200 200]);
ylim([-200 200]);
zlim([0 2500]);
xlabel('x');
ylabel('y');
zlabel('z');
title('Phase Space');
subplot(3,1,2)
phasesp_2a = animatedline('Color','#808080', 'LineWidth', 0.25);
phasesp_2b = animatedline('Marker','.', 'MarkerSize', 20, 'Color', '#7E2F8E');
ylim([15 32.5]);
yline(20, 'k--');
ylabel('w');
title('Frequency Adaptation');
subplot(3,1,3)
phasesp_3a = animatedline('Color','#808080', 'LineWidth', 0.25);
phasesp_3b = animatedline('Marker','.', 'MarkerSize', 20, 'Color', '#7E2F8E');
ylabel('y');
xlabel('Time');
title('Oscillation (y component)');

gif('Rossler_PhaseP.gif')

for k = 1:10:8000
    x_k = y(k,1);
    y_k = y(k,2);
    z_k = y(k,3);
    w_k = y(k,4);
    subplot(3,1,1)
    addpoints(phasesp_1a, x_k,y_k, z_k);
    addpoints(phasesp_1b, x_k,y_k, z_k);
    sgtitle(sprintf('Steps %0.2f',k));
    subplot(3,1,2)
    addpoints(phasesp_2a, k, w_k);
    addpoints(phasesp_2b, k, w_k);
    subplot(3,1,3)
    addpoints(phasesp_3a, k, y_k);
    addpoints(phasesp_3b, k, y_k);
    drawnow
    gif
    clearpoints(phasesp_1b)
    clearpoints(phasesp_2b)
    clearpoints(phasesp_3b);
end

