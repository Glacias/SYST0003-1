ABCD;
K_script;

sys_tf = tf(sys);
P_s = sys_tf(2);

% Design of C(s)

C_s = tf([1 0.001],[1 1]);

% L(s)
L_s = C_s * P_s;

% Sensitivity S(s)
S_s = 1/(1+L_s)
pole_S_S = pole(S_s)

% Load sensitivity PS(s)
PS_s = P_s * S_s
pole_PS_S = pole(PS_s)

% Complementary sensitivity T(s)
T_s = L_s /(1 + L_s)
pole_T_S = pole(T_s)

% Noise sensitivity CS(s)
CS_s = C_s /(1 + L_s)
pole_CS_S = pole(CS_s)

%sys_K_tf = tf(sys_k);

figure(1)
bode(C_s)
figure(2)
bode(L_s)
figure(3)
nyquist(L_s*-1)