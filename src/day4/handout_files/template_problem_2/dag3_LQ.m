%% Initialization and model definition
"../init_files_2021_v2/init.m"; % Change this to the init file corresponding to your helicopter

delta_t	= 0.25; % sampling time

%System matrices
A1 = [
    1, delta_t, 0, 0;
    0, 1, -delta_t*K_2, 0;
    0, 0, 1, delta_t;
    0, 0, -K_1*K_pp * delta_t, 1 - K_1*K_pd * delta_t];
B1 = [
    0;
    0;
    0;
    K_1*K_pp * delta_t
    ];



% Time horizon and initialization
N  = 100;                                  % Time horizon for states
M  = N;                                 % Time horizon for inputs
z  = zeros(N*mx+M*mu,1);                % Initialize z for the whole horizon
z0 = z;   



diagonal_1 = [10,.1,.1,.1];
%Defining components in LQ-controller
Q = diag(diagonal_1);
R = diag(10);
disp(Q)
disp(R)
%Solving for optimal gain matrix K
[K,S,P] = dlqr(A1, B1, Q, R);


