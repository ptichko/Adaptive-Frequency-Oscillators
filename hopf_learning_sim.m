%% Figure 2 from Righetti, Buchli, and Ijspeert, (2006)
% start/stop simulation
t0 = 0;
tend = 3000; % fig 2.
Fs = 120; %500

% input signal
F_t = linspace(t0, tend, tend*Fs);
F = cos(30*F_t);
plot(F)

% model parameters
m = 1;                  % osc amplitude
e = [1 ;0.8; 0.6; 0.4]; % learning rates from fig 2.
tspan = [t0 tend];      % full timespan
%tspan = [cos_t];        % time point as cos

% integration 
for i = 1:length(e)
[t, y] = ode45(@(t,x)hopf_learn(t,x, m, e(i), F, F_t)...
    ,tspan, [0, 1, 40] );
    plot(t,y(:,3), 'black');
    hold on
end

title('Adaptive-Frequency Hopf Oscillator with Hebbian Learning')
xlabel('Time')
ylabel('W (Angular Frequency)')
legend(num2str(e))
hold off;

%% Multiple initial conditions
% start/stop simulation
t0 = 0;                 % start time
tend = 800;             % end time
Fs = 120;               % sample rate of input signal

% periodic forcing (cosine input)
F_t = linspace(t0, tend, tend*Fs);
F = cos(30*F_t);
plot(F); ylim([-1.5 1.5]);

% model parameters
m = 1;                  % osc amplitude
e = 1;                  % learning rate
w0 = [18; 26; 36; 42];  % initial conditions for osc freq
tspan = [t0 tend];      % full timespan
%tspan = [cos_t];       % time point as cos

% integration 
for i = 1:length(w0)
[t, y] = ode45(@(t,x)hopf_learn(t,x, m, e, F, F_t)...
    ,tspan, [0, 1, w0(i)] );
    plot(t,y(:,3), 'black');
    hold on
end

title('Adaptive-Frequency Hopf Oscillator with Hebbian Learning')
xlabel('Time')
ylabel('W (Angular Frequency)')
legend(num2str(w0))
hold off;


%% One Rhythmic Frequency 
% start/stop simulation
t0 = 0;
tend = 250; % 3000, fig 2.
Fs = 120; % 500

% periodic forcing (cosine input)
F_t = linspace(t0, tend, tend*Fs);
F = cos(3*F_t);
%plot(F)

% model parameters
m = 1;                  % osc amplitude
e = [1 ;0.8; 0.6; 0.4]; % learning rates from fig 2.
%tspan = [t0 tend];      % full timespan
tspan = [F_t];        % time point as cos

for i = 1
[t, y] = ode45(@(t,x)hopf_learn(t,x, m, e(i), F, F_t)...
    ,tspan, [0, 1, 10] );
end

figure(1);
hold on
plot(t,y(:,3), 'black');
title('Adaptive-Frequency Hopf Oscillator with Hebbian Learning')
xlabel('Time')
ylabel('W (Angular Frequency)')
legend(num2str(e(i)))
hold off;


% Time series of w-dot and oscs
figure(2);
hold on
subplot(2,1,1)
plot(t,y(:,3), 'black', 'LineWidth', 1.5);
xlim([110 160])
title('Dynamics of Frequency Adaptation')
xlabel('Time')
ylabel('W (Angular Frequency)')
legend(num2str(e(i)))
hold off;

figure(2); 
subplot(2,1,2)
plot(t,F, '--black', 'LineWidth', 1.5);
hold on;
plot(t,y(:,2), 'LineWidth', 2, 'Color', '#7E2F8E');
xlim([110 160]);
title('Input Signal and Oscillator')
xlabel('Time')
ylabel('Amplitude')
legend('F', 'Oscillator')
hold off;


% phase portrait
figure;
hold on;
plot(y(:,1),y(:,2),	'Color','#808080', 'LineWidth', 0.5)
plot(y(1,1),y(1,2),'.-', 'MarkerSize', 20, 'Color', '#7E2F8E')        % initial conditions
plot(y(end,1),y(end,2),'.-','MarkerSize', 20)    % final position
title(['Phase Portrait: e = ' num2str(e(i))]);
xlabel('x-dot');
ylabel('y-dot');
hold off
%%
% tspan for gif
[~, gifStart] = min(abs(120-t));
[~, gifStop] = min(abs(145-t));

% gif
fig2 = figure;
fig2.Position = [823   264   417   714];
subplot(3,1,1)
phasesp_1a = animatedline('Color','#808080', 'LineWidth', 0.25);
phasesp_1b = animatedline('Marker','.', 'MarkerSize', 20, 'Color', '#7E2F8E');
xlim([-1.5 1.5]);
ylim([-1.5 1.5]);
xlabel('x');
ylabel('y');
title('Phase Space');
subplot(3,1,2)
phasesp_2a = animatedline('Color','#808080', 'LineWidth', 0.25);
phasesp_2b = animatedline('Marker','.', 'MarkerSize', 20, 'Color', '#7E2F8E');
xlim([t(gifStart) t(gifStop)]);
ylim([2 10]);
yline(3, 'k--');
ylabel('w');
title('Frequency Adaptation');
subplot(3,1,3)
phasesp_3a = animatedline('Color','#7E2F8E', 'LineWidth',1);
phasesp_3b = animatedline('LineStyle', '--','Color','#808080', 'LineWidth', 1);
xlim([t(gifStart) t(gifStop)]);
ylim([-1.2 1.2]);
ylabel('y');
xlabel('Time');
title('Oscillation (y-var) and Input Signal (dashed)');

gif('Hopf_PhaseP.gif')


for k = gifStart:5:gifStop
    x_k = y(k,1);
    y_k = y(k,2);
    w_k = y(k,3);
    F_k = F(k);
    subplot(3,1,1)
    addpoints(phasesp_1a, x_k,y_k);
    addpoints(phasesp_1b, x_k,y_k);
    sgtitle(sprintf('Steps %0.2f',k));
    subplot(3,1,2)
    addpoints(phasesp_2a, t(k), w_k);
    addpoints(phasesp_2b, t(k), w_k);
    subplot(3,1,3)
    addpoints(phasesp_3a, t(k), y_k);
    addpoints(phasesp_3b, t(k), F_k);
    drawnow
    gif
    clearpoints(phasesp_1b)
    clearpoints(phasesp_2b)
end



%% Multiple rhythmic frequencies
% start/stop simulation
t0 = 0;
tend = 50; 
Fs = 120;

% input signal
f1 = 3;
f2 = 6;
f3 = 9;
F_t = linspace(t0, tend, tend*Fs);
F = sin(f1*F_t) + cos(f2*F_t) + sin(f3*F_t) ;
plot(F)

% model parameters
m = 1;                  % osc amplitude
e = 1;                  % learning rate
%tspan = [t0 tend];     % full timespan
tspan = [F_t];          % time point as cos
w0 = [1;4;5;10];         % initial osc freqs

y_comp = [];

for i = 1:length(w0)
[t, y] = ode45(@(t,x)hopf_learn(t,x, m, e, F, F_t)...
    ,tspan, [0, 1, w0(i)] );
    plot(t,y(:,3), 'black');
    y_comp(:,i) = y(:,2);
    hold on
end

yline(f1,'k--');
yline(f2,'k--');
yline(f3,'k--');
title('Adaptive-Frequency Hopf Oscillator with Hebbian Learning')
xlabel('Time')
ylabel('W (Angular Frequency)')
legend(num2str(w0))
hold off;



figure; 
subplot(4,1,1)
plot(t,F, '-black', 'LineWidth', 1.5);
hold on;
plot(t,y_comp(:,4),'LineWidth', 2, 'Color', '#D95319')
ylabel('Amplitude')
legend('F', ['Oscillator'])
title([num2str(w0(4)) '-Hz Oscillator'])
hold off;

subplot(4,1,2)
hold on;
plot(t,F, '-black','LineWidth', 1.5);
plot(t,y_comp(:,3),'LineWidth', 2,'Color', 	'#D95319')
ylabel('Amplitude')
title([num2str(w0(3)) '-Hz Oscillator'])
hold off;

subplot(4,1,3)
hold on;
plot(t,F, '-black','LineWidth', 1.5);
plot(t,y_comp(:,2),'LineWidth', 2, 'Color', '#D95319');
ylabel('Amplitude')
title([num2str(w0(2)) '-Hz Oscillator'])
hold off;

subplot(4,1,4)
hold on;
plot(t,F, '-black','LineWidth', 1.5);
plot(t,y_comp(:,1),'LineWidth', 2, 'Color', 	'#D95319');
ylabel('Amplitude')
title([num2str(w0(1)) '-Hz Oscillator'])
hold off;

xlim([1 40]);
xlabel('Time')
ylabel('Amplitude')


%% Musical Rhythm
% NOT CURRENTLY WORKING
Fs = 120; % 500

%%%%%% Make stimulus %%%%%%  
s = stimulusMake(1, 'mid', 'Iso_2_1_Original_120BBPM_32cycles.mid', 'display', 1, 'fs', Fs);   % Western training rhythm
%s = stimulusMake(1, 'mid', 'NonIso_3_2_Original_120BPM_32cycles.mid', 'display', 1); % Balkan training rhythm

% start/stop simulation
t0 = s.t(1);
tend = s.t(end); % 3000, fig 2.

F_t = s.t;
s.x = 0.16*s.x/rms(s.x);      
F = s.x;
plot(F_t,F);

% model parameters
m = 1;                  % osc amplitude
e = 2; 
%tspan = [t0 tend];     % full timespan
tspan = [F_t];        % time point as cos


for i = 1
[t, y] = ode45(@(t,x)hopf_learn(t,x, m, e(i), F, F_t)...
    ,tspan, [0, 1, 8] );
end

figure;
hold on
plot(t,y(:,3), 'black');
title('Adaptive-Frequency Hopf Oscillator with Hebbian Learning')
xlabel('Time')
ylabel('W (Angular Frequency)')
legend(num2str(e(i)))
hold off;

% Time series 
figure; 
hold on;
plot(t,F, '--black');
plot(t,y(:,2), 'blue');
plot(t,y(:,1), '--blue');
xlim([t0 10]);
title('Adaptive-Frequency Hopf Oscillator with Hebbian Learning')
xlabel('Time')
ylabel('Amplitude')
legend('F', 'Oscillator')
hold off;




      