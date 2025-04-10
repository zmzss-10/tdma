% 参数设置
numUsers = 1;          % 用户数量
numSlots = 2;         % 每个超帧的时隙数量
numFrames = 10;       % 超帧数量
lambda = 10;           % 泊松分布的到达率（λ），这里设为较大值

% 初始化每个超帧的时隙状态
dataArrival = zeros(numFrames, numSlots, numUsers); % 维度: [超帧, 时隙, 用户]

% 进行仿真
for frame = 1:numFrames
    for user = 1:numUsers
        % 对于每个用户，生成每个时隙的数据到达情况
        for slot = 1:numSlots
            % 生成泊松随机数，表示该时隙到达的数据包数量
            numArrivals = poissrnd(lambda); % 生成泊松随机数
            dataArrival(frame, slot, user) = numArrivals; % 记录到达的包数
        end
    end
end

% 示例输出
disp('每个超帧每个时隙到达的包数:');
disp(dataArrival);