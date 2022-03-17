
function [odes] = vanderpol_learn(t,x,a,e, F,F_t)

% An Adaptive-Frequency Van der Pol Oscillator
%
% Dynamic Hebbian learning in adaptive frequency oscillators, Righetti, Buchli, and Ijspeert, 2006
% Implemented by Parker Tichko, 2022
%
% W = Hebbian learning of oscillator frequency
% a = amount of non-linearity in the system, a > 0
% e = learning rate, e > 0
% F = input, often periodic forcing (e.g., sin(t), cos(t))
% F_t = discrete time of F
%
% System is 3 odes expressed in Cartesian coordinates
% X = oscillator
% Y = oscillator
% W = hebbian learning rule for oscillator freq

F = interp1(F_t, F, t);

X = x(1);
Y = x(2);
W = x(3);

dXdt = Y+e*F;
dYdt = -a*((X^2)-1)*Y-W^2*X;
dWdt = e*F*(Y/sqrt(X^2+Y^2));

odes = [dXdt; dYdt; dWdt];
