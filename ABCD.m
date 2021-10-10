
% Parameter
G_b = 90;
V_I = 6;
p1 = 0.00058735;
p2 = 0.028344;
p3 = 5.035*10^-5;
p4 = 0.3;
d_rate = 0.05;

%p0 = 195; p1 = 0.0001; p2 = 0.02093; p3 = 1.062E?5; p4 = 0.3; p5 = 94; p6 = 0.003349;

% Equilibrium

G_e= 90;
X_e= 0;
I_e= 0;
D_e=0;
m_e= 0;

% ABCD

A = [ -p1 -G_e 0 1 ; 0 -p2 p3 0 ; 0 0 -p4 0; 0 0 0 -d_rate];
B = [0 0 0 1 ; 0 0 1/V_I 0]; B = B.';
C = [1 0 0 0];
D = 0;

% System

sys = ss(A,B,C,D);

% Simulation


% dt = 0.5;
% Tfinal = 16*60;
% t = 0:dt:Tfinal;
% 
% length(t);
% 
% k = zeros(1,length(t)-720);
% k1 = zeros(1,638);
% k2 = zeros(1,640);
% k3 = [8 k2 12 k2 10 k1];
% 
% u = [k3 ; zeros(1,length(k3))];

dt = 0.5;
Tfinal = 20*60;
t = 0:dt:Tfinal;

length(t);

k = zeros(1,length(t)-720);
k1 = zeros(1,638);
k2 = zeros(1,640);
k3 = [8 k2 12 k2 10 k1 zeros(1, 480)];

u = [k3 ; zeros(1,length(k3))];

y = lsim(sys,u,t);

%Stability

sta = isstable(sys);

%Observability

obs = obsv(sys);
obs_rank = rank(obs);

%Controllability 

co = ctrb(sys);
co_rank = rank(co);





