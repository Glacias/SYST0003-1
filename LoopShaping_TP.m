%% Matlab script - transferFunctions
% Analysis of the system in the frequency domain
close all 
clear all


%% Parameters
m = 2;

u2_t =       [0  1  2  3  4  5  6  7  8  9  10 11 12   13   14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50  ]'*0.1;
u2_value  =  [40 42 44 46 48 50 52 54 56 58 60 62 64 66 68 70 72 74 76 78 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 100 100 100 100 100 100 100 100 100 100  ]'*0.01;
u2 = [u2_t u2_value];


figure(1)
plot(u2_t, u2_value,'b', 'LineWidth',1.5)
xlabel('Time(s)','fontsize',14)
ylabel('Position (m)','fontsize',14)
grid on


% SYSTEM : state space representation 
A = [0 1; 0 0];
B = [0 0; 1/m 0];
C = [-1 0];
D = [0 1];
system = ss(A,B,C,D);


% transfer function of the open loop system
H = tf(system); 


%% OPEN LOOP SYSTEM
% First input

Num1 = -1/m;
Den1 = [1,0,0];
P = tf(Num1,Den1)
figure
bode(P)
title('')
%set(gca,'TickLabelInterpreter','latex','fontsize', 16)
%set(gcf,'PaperPositionMode','auto');
%set(gcf, 'PaperUnits', 'centimeters');
%set(gcf, 'PaperPosition', [0 0 6 10]);

%% cross over frequency
wc = 20; 


%% LEAD


      
% theoritical developement with phase margin
% Gl = Glo * ( 1 + s/wz ) / ( 1 + s/wp ) 


Pm = [ 50 60 80 ];

figure
for k=1:1:3
    alpha = 0.5*(pi/2 - (Pm(k)*pi/180));
    w_zVar(k) = wc* tan(alpha);
    w_pVar(k) = wc / tan(alpha);
    
    Num_LVar = [1/w_zVar(k),1];
    Den_LVar = [1/w_pVar(k),1];
    G_LVar = tf(Num_LVar,Den_LVar);
    G_LoVar(k) = 1/bode(G_LVar*P,wc);
    
    L_1Var(k) =-P*G_LVar*G_LoVar(k);
    
    hold on
    bodeplot(L_1Var(k));
    grid on
    
    % save the values of the margin
end
title('')
legend('Pm=60°', 'Pm=70°', 'Pm=80°')
hold off

% relative distance simulation
color = [ 'b', 'g', 'k'];

figure
for k = 1:1:3
    w_zSim=w_zVar(1,k);
    w_pSim=w_pVar(1,k);
    G_LoSim = G_LoVar(k);
    sim('LoopShapingLead');
    hold on
    grid on
    plot(y.Time,y.Data, color(k))
end
%title('relative distance for different Pm')
legend('Pm=60°', 'Pm=70°', 'Pm=80°')
xlabel('Time (s)','fontsize',14)
ylabel('Distance (m)','fontsize',14)
hold off



% Acceleration simulation
figure
for k = 1:1:3
    w_zSim=w_zVar(1,k);
    w_pSim=w_pVar(1,k);
    G_LoSim = G_LoVar(k);
    sim('LoopShapingLead');
    hold on
    grid on
    plot(acc.Time,acc.Data, color(k))
end
  %title('acceleration for different Pm')
  legend('Pm=60°', 'Pm=70°', 'Pm=80°')
  xlabel('Time (s)','fontsize',14);
  ylabel('Acceleration (m/s^2)','fontsize',14);
  hold off
  
  
%% CHOSEN LEAD COMPENSATOR
% used in the following development

  % theoritical developement with phase margin = 70°
  % Gl = Glo * ( 1 + s/fz ) / ( 1 + s/fp ) 
alpha = 0.5*(pi/2 - (70*pi/180)); % Pm=70 
w_z = wc* tan(alpha);
w_p= wc / tan(alpha);
 
Num_L = [1/w_z,1];
Den_L = [1/w_p,1];
G_L = tf(Num_L,Den_L)
G_Lo = 1/bode(G_L*P,wc);

L_1 =-P*G_L*G_Lo

% figure
% bode(G_L)
% title('GL')

figure
bodeplot(L_1)
title('L1')
grid on
[Gm_L, Pm_L, Wcg_L, Wcp_L]=margin(L_1);


  
  
%% LOW PASS FILTER 1 

% Filter HF 
% this low pass filter rejects the effect of high frequencies

% 
% %LOW PASS FILTER FOR DIFFERENT w_hf
% w_hfVar = [ 200 300 400 ]; 
% figure
% for k=1:1:3
%     Num_hfVar=w_hfVar(k);
%     Den_hfVar=[1,w_hfVar(k)];
%     G_hfVar=tf(Num_hfVar,Den_hfVar)
%     G_hfoVar(k) = 1/bode(G_hfVar*P*G_L,wc);
%     L_2Var(k) =-P*G_L*G_hfVar*G_hfoVar(k);
%     
%     hold on
%     bodeplot(L_2Var(k));
%     grid on
%     
%     [Gm2(k), Pm2(k), Wcg2(k), Wcp2(k)]=margin(L_2Var(k));
% end
% title('')
% legend('w_hf=200rad/s', 'w_hf=300rad/s', 'w_hf=400rad/s')
% hold off
% 
% color = [ 'b', 'g', 'k'];
% 
% %dist
% figure
% for k = 1:1:3
%     w_hfSim=w_hfVar(1,k);
%     G_hfoSim = G_hfoVar(k);
%     sim('LoopShapingHF');
%     hold on
%     grid on
%     plot(y.Time,y.Data, color(k))
% end
% %title('relative distance for different f_{hf}')
% legend('w_hf=200rad/s', 'w_hf=300rad/s', 'w_hf=400rad/s')
% xlabel('Time (s)','fontsize',14)
% ylabel('Distance (m)','fontsize',14)
% hold off
% 
% %a
% figure
% for k = 1:1:3
%     w_hfSim=w_hfVar(1,k);
%     G_hfoSim = G_hfoVar(k);
%     sim('LoopShapingHF');
%     hold on
%     grid on
%     plot(acc.Time,acc.Data, color(k))
% end
%   %title('acceleration for different f_{hf}')
% legend('w_hf=200rad/s', 'w_hf=300rad/s', 'w_hf=400rad/s')
% xlabel('Time (s)','fontsize',14);
% ylabel('Acceleration (m/s^2)','fontsize',14);
% hold off


%% FINAL CONTROLLER

% chosen filter
w_hf=300; 
Num_hf=w_hf;
Den_hf=[1,w_hf];
G_hf=tf(Num_hf,Den_hf)

Go= 1/ bode(G_hf*P*G_L,wc);

% CONTROLLER
C = G_L*G_hf*Go

% figure
% bodeplot(C)
% title('C');

% LOOP TRANSFER FUNCTION
L=-P* C

figure
bodeplot(L)
title('')
xlabel('Frequency','fontsize',14)
ylabel('Phase','fontsize',14)


[GainAtCo_L, PhaseAtCo_L, wCo_L] = bode(L, wc);
[Gm_L, Pm_L, Wcg_L, Wcp_L]=margin(L);


% SIMULATIONS
sim('LoopShapingTOT');
%plot
figure
hold on
subplot(2, 1, 1)
plot(y_cont.Time,y_cont.Data)
title('')
xlabel('Time (s)','fontsize',14)
ylabel('Distance (m)','fontsize',14)
grid on
subplot(2, 1, 2)
plot(acc_cont.Time,acc_cont.Data)
title('')
xlabel('Time (s)','fontsize',14)
ylabel('Acceleration (m/s^2)','fontsize',14)
grid on


%% NOISE

% 
% sim('LoopShapingNoisy')
% figure
% plot(y.Time,y.Data)
% %title('relative dist')
% xlabel('Time (s)','fontsize', 14)
% ylabel('Distance (m)', 'fontsize', 14)
% grid on
% 
% 
% figure
% plot(acc.Time,acc.Data)
% %title('acceleration')
% xlabel('Time (s)','fontsize', 14);
% ylabel('Acceleration (m/s^2)','fontsize', 14);
% grid on
%   
  
  
%% DELAYS

% 
t_d1=0.03
t_d2=0.05;
t_d3=0.07;
s = tf('s');
sys1 = exp(-t_d1*s)
sys2 = exp(-t_d2*s)
sys3 = exp(-t_d3*s)
L_del1=ss(sys1);
L_del2= ss(sys2); 
L_del3=ss(sys3);

[Gm_del1, Pm_del1, Wcg_del1, Wcp_del1]=margin(L_del1);
[Gm_del2, Pm_del3, Wcg_del2, Wcp_del2]=margin(L_del2);
[Gm_del2, Pm_del3, Wcg_del3, Wcp_del3]=margin(L_del3);

figure
hold on
bodeplot(L*L_del1)
bodeplot(L*L_del2)
bodeplot(L*L_del3)
title('')
  legend('t_d=0.03s', 't_d=0.05s', 't_d=0.07s')
hold off

figure
hold on
nyquist(L*L_del1);
nyquist(L*L_del2)
nyquist(L*L_del3)
title('')
legend('t_d=0.03s', 't_d=0.05s', 't_d=0.07s')
axis([-1.5 1.5 -0.6 0.6])
hold off


  color = [ 'b', 'g', 'k', 'c', 'm','y' ];
  t_delayVar = [ 0.01 0.02 0.03 0.04 0.05 ]
  figure
for k = 1:2:5
    t_delay = t_delayVar(k);
    sim('LoopShapingDELAY');
    hold on
    plot(y.Time,y.Data,color(k))
end
legend('t_d=0.03s', 't_d=0.05s', 't_d=0.07s')
xlabel('Time (s)', 'fontsize', 14)
ylabel('Distance (m)', 'fontsize', 14)
 grid on
hold off


  figure
for k = 1:2:5
    t_delay = t_delayVar(k);
    sim('LoopShapingDELAY');
    hold on
    plot(acc.Time,acc.Data,color(k))
end
  %title('relative distance for different f_{hf}')
   legend('t_d=0.03s', 't_d=0.05s', 't_d=0.07s')
  xlabel('Time (s)', 'fontsize', 14)
 ylabel('Acceleration (m/s^2)', 'fontsize', 14)
 grid on
hold off
