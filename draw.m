
value=load('tdma.mat');
value_2=load('dynamictdma.mat');
data=value.data;
data_2=value_2.data;

starttime=value.starttime;
endtime=value.endtime;
step=value.step;
PacketLength=value.PacketLength;
delta=value.delta;
x=starttime:step:endtime;
x=(x*PacketLength)./(delta);
y=1:32;


% 平均时延---------------------------------------------------------------
figure(5);
delayAver = zeros(length(y), length(x));
delayAver_2 = zeros(length(y), length(x));
for i = 1:length(y)
    for j= 1:length(x)
        delayAver(i, j) = data(i).delayAver(1,j); % 将结构体中的z值填入Z矩阵
        delayAver_2(i, j) = data_2(i).delayAver(1,j);
    end
end
delayAver(isnan(delayAver)) = 0; 
delayAver_2(isnan(delayAver_2)) = 0;
h1=surf(x,y,delayAver);hold on;
h2=surf(x,y,delayAver_2);
set(h1, 'FaceColor', 'blue', 'EdgeColor', 'k'); % 使用插值的面颜色和黑色边缘
set(h2, 'FaceColor', 'red', 'EdgeColor', 'k'); % 设置颜色
xlabel('数据包到达率(b/s)');
ylabel('节点数量');
zlabel('平均时延/s');
grid on;  
hold off;
legend('固定分配', '动态分配');
% 分组投递率---------------------------------------------------------------       
figure(6);
deliveryRate = zeros(length(y), length(x));
deliveryRate_2 = zeros(length(y), length(x));
for i = 1:length(y)
    for j= 1:length(x)
        deliveryRate(i, j) = data(i).deliveryRate(1,j); % 将结构体中的z值填入Z矩阵
        deliveryRate_2(i, j) = data_2(i).deliveryRate(1,j);
    end
end
deliveryRate(isnan(deliveryRate)) = 0;
deliveryRate_2(isnan(deliveryRate_2)) = 0;
h3=surf(x,y,deliveryRate);hold on;
h4=surf(x,y,deliveryRate_2);
set(h3, 'FaceColor', 'blue', 'EdgeColor', 'k'); % 使用插值的面颜色和黑色边缘
set(h4, 'FaceColor', 'red', 'EdgeColor', 'k'); % 设置颜色
xlabel('数据包到达率(b/s)');
ylabel('节点数量');
zlabel('分组投递率');
grid on;  
legend('固定分配', '动态分配');
% 平均吞吐量---------------------------------------------------------------
figure(7);
averageThroughput = zeros(length(y), length(x));
averageThroughput_2 = zeros(length(y), length(x));
for i = 1:length(y)
    for j= 1:length(x)
        averageThroughput(i, j) = data(i).averageThroughput(1,j); 
        averageThroughput_2(i, j) = data_2(i).averageThroughput(1,j); % 将结构体中的z值填入Z矩阵
    end
end
h5=surf(x,y,averageThroughput);hold on;
h6=surf(x,y,averageThroughput_2);
set(h5, 'FaceColor', 'blue', 'EdgeColor', 'k'); % 使用插值的面颜色和黑色边缘
set(h6, 'FaceColor', 'red', 'EdgeColor', 'k'); % 设置颜色
xlabel('数据包到达率(b/s)');
ylabel('节点数量');
zlabel('平均吞吐量/bps');
grid on;  
legend('固定分配', '动态分配');
% 时隙利用率---------------------------------------------------------------
figure(8);
slotUtilization = zeros(length(y), length(x));
slotUtilization_2 = zeros(length(y), length(x));
for i = 1:length(y)
    for j= 1:length(x)
        slotUtilization(i, j) = data(i).slotUtilization(1,j); % 将结构体中的z值填入Z矩阵
        slotUtilization_2(i, j) = data_2(i).slotUtilization(1,j);
    end
end
h7=surf(x,y,slotUtilization);hold on;
h8=surf(x,y,slotUtilization_2);
set(h7, 'FaceColor', 'blue', 'EdgeColor', 'k'); % 使用插值的面颜色和黑色边缘
set(h8, 'FaceColor', 'red', 'EdgeColor', 'k'); % 设置颜色
xlabel('数据包到达率(b/s)');
ylabel('节点数量');
zlabel('时隙利用率');
grid on;  
legend('固定分配', '动态分配');
% 
