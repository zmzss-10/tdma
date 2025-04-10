% 参数设置
numSuperframes = 1000;  % 超帧数
len = 100;              % 仿真次数
serviceSlots = 32;      % 业务时隙数 (从第3到第34，共32个)
numSlots = 34;          % 总时隙数 
slot_time=10^(-3);

% 存储不同节点数下的平均接入时间
accessTimeAverage = zeros(maxNodes, 1);

for times = 1:len
    numNodes=32;% 节点数
    index=0;
    packet=zeros(numNodes,3);
    totalAccessTime = 0;
    flag=zeros(numNodes,1);
    totnum=0;
    queueNode=[];
    
    for superframe = 1:numSuperframes
        
        if(~isempty(queueNode))
            % 按照预计发送时间排序
            queueNode = sortrows(queueNode, 4);
%             disp(superframe);
%             disp(queueNode);
%             disp('----------------');
            % 最早发送时间
            minValue = queueNode(1,4);
            % 找到当前超帧需要发送的节点
            if(minValue <= superframe)
                % 获取所有最小值的行
                nums=0;
                for i=1:size(queueNode, 1)
                    if(queueNode(i,4)==minValue)
                        nums=nums+1;
                    else
                        break;
                    end
                end
                if(nums == 1)
                    % 只有一个待发送节点,进行发送
                    index=index+1;
                    packet(index,1)=queueNode(1,1);
                    packet(index,2)=queueNode(1,2);
                    packet(index,3)=queueNode(1,4);
                    totalAccessTime=totalAccessTime + (numSlots-queueNode(1,3)) + numSlots*(queueNode(1,4)-queueNode(1,2)-1) + numSlots+1;
                    queueNode(1, :) = []; 
                    totnum=totnum+1;
                    if(totnum==numNodes)
                        break;
                    end
                else
                    % 多个待发送节点，随机退避
                   
                    backoffTime = randi([1, numNodes], nums, 1); 
                    queueNode(1:nums, 4) =queueNode(1:nums, 4) + backoffTime;  % 将随机数加到第四列
                end
            end
        end
            
        % 随机生成每个节点的申请需求
        request = rand(numNodes, 1) < 0.5;  % 50%概率产生申请需求
        for i = 1:numNodes
            if request(i)  % 如果请求为真
                if flag(i,1)  % 如果标志已设置
                    request(i) = false;  % 取消申请
                else
                    flag(i,1) = true;  % 设置标志
                end
            end
        end
        
        % 若存在有需求的节点
        requestindex = find(request);         
        if(~isempty(requestindex))
            requestnodes = [requestindex,zeros(size(requestindex,1),3)];
            for i= 1:size(requestindex,1)
                % 有申请需求的帧序号
                requestnodes(i,2)=superframe; 
                % 有申请需求的时隙号
                requestnodes(i,3)=floor(randi([1,34]));
                % 预计发送申请需求的帧序号
                requestnodes(i,4)=superframe+1;
            end
            queueNode=[queueNode;requestnodes];
        end
        
    end
    
    % 计算平均接入时间
    accessTimeAverage(times) = slot_time*totalAccessTime / numNodes;
end   

% save('1.mat');
save('32.mat');
% 绘制结果
figure;
plot(1:len, accessTimeAverage, '-o', 'LineWidth', 2);
xlabel('节点数');
ylabel('平均接入时间/s');
title('不同节点数下的时隙申请时间');
grid on;