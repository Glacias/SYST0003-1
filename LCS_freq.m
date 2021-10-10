%%Premier test pour LCS projet 2
overshoot = 0.15; %[-]
delay = 50; %[ms]
measure_noise = 100; %[Hz]
F_c = 10; %[N]
m = 0.5; %[kg]
r = 50;%[m] altitude de référence? Prise au hasard
% Kp = 1;
% Ki = 1;
% Kd = 1;
k = 200;
s = tf('s');
P = 1/((s^2)*m);
H_p = 1/((s^2)*m);
H_2 = 1/(s+10);
H_3 = (s+0.1)/(s+10);
H_4 = (s+1)/(s+0.1);
L = k*P*H_2*H_3*H_4;

LP = 1/(s+50);
Lead = (s+1)/(s+10);
Lag = (s+0.5)/(s+0.1);
H_perso = (s+10)/(s+50);
C = 25000*H_perso*Lead*LP;
L_test = P*C;

L_2 = P*25000*(s+1)/(s+50)*LP;

t_d1=0.03;
t_d2=0.05;
t_d3=0.2;
s = tf('s');
sys1 = exp(-t_d1*s);
sys2 = exp(-t_d2*s);
sys3 = exp(-t_d3*s);
L_del1=ss(sys1);
L_del2= ss(sys2); 
L_del3=ss(sys3);

L_delay = L_2*L_del3;

T = L_test/(1 + L_test);
S = 1/(1 + L_test);
CS = C/(1 + L_test);
PS = P/(1 + L_test);
%H_other = H_c-H_p;

% bode(s)
% nyquist(s)
