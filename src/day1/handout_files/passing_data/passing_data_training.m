%% (You do not need to change the first part -> scroll down)
% The data used in this task is just dummy-data and it has no real meaning.

% Let's emphasize that again: The data presented below is nonsense and should
% not be used for other tasks!!

% Let's assume that the "helicopter" (state-space model in the handed out 
% simulink file) is supposed to do the following for the travel: 
%    - Start to go to x0=3.
%    - at time 2 seconds, the reference change to 4.
%    - at time 6 seconds, the reference change to 1.
% There are two states in the model: the travel x1 and the elevation x2.
% The move should be performed in 10 seconds. The sampling
% time can be set to h=0.25. The elevation reference is kept at zero at 
% all times.
%clear all;
h = 0.25;
T_0=0;
T_1=2;
T_2=6;
T = 10; % Simulation horizon
N = T/h; % Number of steps
%x_travel_ref = [ones((T_1-T_0)/h+1, 1)*pi; ones((T_2-T_1)/h, 1)*1.5*pi; ones((T-T_2)/h, 1)*0];
x_travel_ref = [ones((T_1-T_0)/h+1, 1)*3; ones((T_2-T_1)/h, 1)*4; ones((T-T_2)/h, 1)*1];
x_elevation_ref = zeros(size(x_travel_ref));
time_steps = [0:h:T]';

x_tot_ref = [x_travel_ref, x_elevation_ref];
% The handed out simulink diagram named "dummy_system" can be used to get
% some practice in passing and storing data. The skeleton already contains
% a state-space model (with parameters given below), and a simple 
% PI-controller. 



%% TO DO: Do the tasks in the exercise text. (CHANGE)
%   Remember, the goal is to learn how to pass data to Simulink, Store data
%   from Simulink, and finally plot data.


% your code goes here

dummydata = get(out.simout);
time = dummydata.Time;
f_x = dummydata.Data;
disp(dummydata);

travel_ts = timeseries(x_travel_ref, time_steps);
elev_ts = timeseries(x_elevation_ref, time_steps);

assignin('base', 'sim_input_trav',travel_ts);
assignin('base', 'sim_input_elev', elev_ts);
% 
legend({'input ', 'output'})
plot(time,f_x, 'Linewidth', 1);
xlabel('time');
ylabel('f(x)');
grid on;
title('2x2 diff.eq system')

%% Fake-model parameters (You should not change this part)
A = [-0.98, 0; 0, -0.9];
B = [1 0; 0,0];
D = [0,0;0,0];
C = [1,0;0,1];
X0 = [pi;2];


