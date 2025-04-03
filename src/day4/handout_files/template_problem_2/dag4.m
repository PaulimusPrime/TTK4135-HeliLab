"../init_files_2021_v2/init.m";

delta_t	= 0.25; % sampling time
N = 40;

A = [
    0,              1,              0,                  0,               0,         0;
    0,              0,             -K_2,                0,               0,         0;
    0,              0,              0,                  1,               0,         0;
    0,              0,          -K_1*K_pp,          -K_1*K_pd,           0,         0;
    0,              0,              0,                  0,               0,         1;
    0,              0,              0,                  0,           -K_3*K_ep, -K_3* K_ed
    ];

B = [
    0,      0;
    0,      0;
    0,      0;
 K_1*K_pp,  0;
    0,      0;
    0,    K_3*K_ep
    ];

% Initial values
x1_0 = pi;                               % Lambda
x2_0 = 0;                               % r
x3_0 = 0;                               % p
x4_0 = 0;                               % p_dot
x5_0 = 0;                               % e
x6_0 = 0;                               %e_dot
x0 = [x1_0 x2_0 x3_0 x4_0, x5_0, x6_0]';% Initial values

A_disc = eye(6) + delta_t * A;
B_disc = delta_t * B;

nx = size(A,2);
nu = size(B,2);

% Generate system matrixes for linear model
Aeq = gen_aeq(A_disc, B_disc, N, nx, nu);          % Generate A, hint: gen_aeq
beq = zeros(size(Aeq,1),1);                        % Generate b
beq(1:nx) = A_disc*x0;

q1 = 5;
q2 = 5;

% Bounds
ul 	    = 0;                   % Lower bound on control
uu 	    = (1/6) * pi;                   % Upper bound on control

xl      = -Inf*ones(nx,1);              % Lower bound on states (no bound)
xu      = Inf*ones(nx,1);               % Upper bound on states (no bound)
xl(3)   = ul;                           % Lower bound on state x3
xu(3)   = uu;                           % Upper bound on state x3

% Generate constraints on measurements and inputs
[vlb,vub]       = gen_constraints(N,N,xl,xu,ul,uu); % hint: gen_constraints
vlb(N*nx+N*nu)  = 0;                    % We want the last input to be zero
vub(N*nx+N*nu)  = 0;                    % We want the last input to be zero

alpha = 0.2;
beta = 20;
lambda_t = (2* pi) / 3;

A_eq = 0;

Q = diag([2,0,0,0,0,0]);
R = diag([q1, q2]);
G = blkdiag( kron(eye(N),Q), kron( eye(N), R));
C = zeros(size(G,1), 1);

z  = zeros(N*nx+N*nu,1);                % Initialize z for the whole horizon
z0 = z;   

f = @(z) 1/2 * z' * G * z;
opt = optimoptions('fmincon', 'Algorithm', 'sqp', 'MaxFunEvals', 40000);
[Z,ZVAL,EXITFLG] = fmincon(f, z0, [],[], Aeq, beq, vlb, vub, @constraints,opt);

%Q_lqr = diag([5,.2,.1,15,30,10]);
Q_lqr = diag([20,.3,.5,10,30,10]);
R_lqr = diag([.5,.5]);
disp(R_lqr)
[K,S,P] = dlqr(A_disc, B_disc, Q_lqr, R_lqr);
disp(K)

u1  = [Z(N*nx+1:nu:N*nx+N*nu);Z(N*nx+N*nu-1)]; % Control input from solution
u2  = [Z(N*nx+2:nu:N*nx+N*nu);Z(N*nx+N*nu)];

x1 = [x0(1);Z(1:nx:N*nx)];              % State x1 from solution
x2 = [x0(2);Z(2:nx:N*nx)];              % State x2 from solution
x3 = [x0(3);Z(3:nx:N*nx)];              % State x3 from solution
x4 = [x0(4);Z(4:nx:N*nx)];              % State x4 from solution
x5 = [x0(5);Z(5:nx:N*nx)];              % State x4 from solution
x6 = [x0(6);Z(6:nx:N*nx)];              % State x4 from solution



num_variables = 5/delta_t;
zero_padding = zeros(num_variables,1);
unit_padding  = ones(num_variables,1);

u1  = [zero_padding; u1; zero_padding];
u2  = [zero_padding; u2; zero_padding];
x1  = [pi*unit_padding; x1; zero_padding];
x2  = [zero_padding; x2; zero_padding];
x3  = [zero_padding; x3; zero_padding];
x4  = [zero_padding; x4; zero_padding];
x5  = [zero_padding; x5; zero_padding];
x6  = [zero_padding; x6; zero_padding];

optTraj = [x1, x2, x3, x4, x5, x6];


% Plotting
t = 0:delta_t:delta_t*(length(u1)-1);
optTraj = timeseries(optTraj,t);
paadrag1 = timeseries(u1, t);
paadrag2 = timeseries(u2, t);

figure(2)
subplot(511)
stairs(t,u1),grid
ylabel('u')
subplot(512)
plot(t,x1,'m',t,x1,'mo'),grid
ylabel('lambda')
subplot(513)
plot(t,x2,'m',t,x2','mo'),grid
ylabel('r')
subplot(514)
plot(t,x3,'m',t,x3,'mo'),grid
ylabel('p')
subplot(515)
plot(t,x4,'m',t,x4','mo'),grid
xlabel('tid (s)'),ylabel('pdot')
plot(t,x5,'m',t,x5','mo'),grid
xlabel('tid (s)'),ylabel('e')
plot(t,x6,'m',t,x6','mo'),grid
xlabel('tid (s)'),ylabel('edot')

function [c,c_eq] = constraints(z)
global N alpha beta lambda_t nx
   c = zeros(N,1);
   for k = 1:N
       c(k) = alpha * exp(-beta*(z(1+(k-1)*nx)-lambda_t)^2) - z(5+(k-1)*nx);
   end
   c_eq = [];
end








