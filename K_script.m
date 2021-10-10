ABCD;

%%%% K (and k_r)

% Eigenvalue of A
eigA = eig(A)

ctrl_B = [0 0 1/V_I 0].';
% Computation of K and k_r
p = [-0.02 -0.03 -0.3 -0.05];
K = place(A,ctrl_B,p)
%K = [ zeros(1,length(K)) ; K(1,:) ];

% New controlled system

A_k = A - ctrl_B*K;
B_k = B;
C_k = C;
D_k = D;

eigAK = eig(A_k)

sys_k = ss(A_k,B_k,C_k,D_k);

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

y_k = lsim(sys_k,u,t);

hold off
plot(t,y)
hold on
plot(t,y_k)
hold off


