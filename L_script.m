ABCD;
K_script;

% Computation of L

q = [-0.1 -0.03 -0.3 -0.05];
L = place(A',C',q).';

A_l = A - L*C;
B_l = [B L];
C_l = C;
D_l = [0 0 0];

sys_l = ss(A_l,B_l,C_l,D_l);

u = [k3 ; zeros(1,length(k3))];
u(3,:) = y_k;

y_l = lsim(sys_l,u,t);

hold off
plot(t,y_k)
hold on
plot(t,y_l)
hold off