%% Figure 8 from Righetti, Buchli, and Ijspeert, (2006)

% start/stop simulation
t0 = 0;                 % start time
tend = 2500;            % stop time

% periodic forcing (cosine input)
Fs = 120;               % sample rate of periodic forcing
F_t = linspace(t0, tend, tend*Fs); %dt for periodic forcing
F = sin(30*F_t);        
plot(F); ylim([-1.5 1.5]);

% model parameters
a = 50;                 % non-linearity
e = 0.7;                % learning rates from fig 8.
tspan = [t0 tend];      % full timespan
w0 = [18; 26];         % initial conditions for osc freq

for i = 1:length(w0)
[t, y] = ode23(@(t,x)hopf_learn(t,x, a, e, F, F_t)...
    ,tspan, [0, 1, w0(i)] );
    plot(t,y(:,3), 'black');
    hold on
end

title('Adaptive-Frequency Van der Pol Oscillator with Hebbian Learning')
xlabel('Time')
ylabel('W (Angular Frequency)')
legend(num2str(w0))
hold off;

%% One Rythmic Frequency 
% start/stop simulation
t0 = 0;
tend = 300; % 3000, fig 2.
Fs = 120; % 500

% periodic forcing (cosine input)
F_t = linspace(t0, tend, tend*Fs);
F = cos(3*F_t);
%plot(F)

% model parameters
a = 1;                  % non-linearity
e = [1 ;0.8; 0.6; 0.4]; % learning rates from fig 2.
%tspan = [t0 tend];      % full timespan
tspan = [F_t];        % time point as cos

for i = 1
[t, y] = ode45(@(t,x)vanderpol_learn(t,x, a, e(i), F, F_t)...
    ,tspan, [0, 1, 10] );
end

figure(1);
hold on
plot(t,y(:,3), 'black');
title('Adaptive-Frequency Van der Pol Oscillator with Hebbian Learning')
xlabel('Time')
ylabel('W (Angular Frequency)')
legend(num2str(e(i)))
hold off;


% Time series of w-dot and oscs
figure(2);
hold on
subplot(2,1,1)
plot(t,y(:,3), 'black');
xlim([200 250])
title('Dynamics of Frequency Adaptation')
xlabel('Time')
ylabel('W (Angular Frequency)')
legend(num2str(e(i)))
hold off;

figure(2); 
subplot(2,1,2)
plot(t,F, '--black');
hold on;
plot(t,y(:,2), 'blue');
xlim([200 250]);
title('Input and Oscillator')
xlabel('Time')
ylabel('Amplitude')
legend('F', 'Oscillator')
hold off;

% phase portrait
figure;
hold on;
plot(y(:,1),y(:,2))
plot(y(1,1),y(1,2),'-o')        % initial conditions
plot(y(end,1),y(end,2),'-o')    % final position
title(['Phase Portrait: e = ' num2str(e(i))]);
xlabel('x-dot');
ylabel('y-dot');
hold off

%% Multiple rhythmic frequencies
% start/stop simulation
t0 = 0;
tend = 100; % 3000, fig 2.
Fs = 120; % 500

% periodic forcing (cosine input)
cosf1 = 3;
cosf2 = 6;
F_t = linspace(t0, tend, tend*Fs);
F = cos(cosf1*F_t) + cos(cosf2*F_t) ;
plot(F)

% model parameters
a = 1;                  % non-linearity
e = 1;                % learning rate
%tspan = [t0 tend];     % full timespan
tspan = [F_t];          % time point as cos
w0 = [2;4;5;7];         % initial osc freqs

for i = 1:length(w0)
[t, y] = ode45(@(t,x)vanderpol_learn(t,x, a, e, F, F_t)...
    ,tspan, [0, 1, w0(i)] );
    plot(t,y(:,3), 'black');
    hold on
end

yline(cosf1,'k--');
yline(cosf2,'k--');
title('Adaptive-Frequency Van der Pol Oscillator with Hebbian Learning')
xlabel('Time')
ylabel('W (Angular Frequency)')
legend(num2str(w0))
hold off;


%% Musical Rhythm

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




      