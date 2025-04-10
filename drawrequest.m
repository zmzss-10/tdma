a=load('1.mat');
b=load('32.mat');
len=a.len;


figure(1);
subplot(2,1,1);
plot(1:len, a.accessTimeAverage, '-o', 'LineWidth', 2);
xlabel('仿真次数');
ylabel('平均接入时间/s');
title('单节点下的时隙申请时间');
grid on;

subplot(2,1,2);
plot(1:len, b.accessTimeAverage, '-o', 'LineWidth', 2);
xlabel('仿真次数');
ylabel('平均接入时间/s');
title('32节点下的时隙申请时间');
grid on;