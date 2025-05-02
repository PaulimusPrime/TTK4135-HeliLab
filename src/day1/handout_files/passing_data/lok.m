timedata = load('time_data1.mat');
disp(timedata);
legend({'input ', 'output'})
plot(timedata.ans.Time,timedata.ans.data, 'Linewidth', 1);
xlabel('time');
ylabel('f(x)');
grid on;
title('2x2 diff.eq system')