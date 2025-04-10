clear;clc;

delta=10^(-3);      % 单时隙长度秒
PacketLength=72000;      % 数据包长度bit
maxUser = 32;          % 用户数量
numSlots = 32;         % 可用时隙数量
slotaverage=1;         %每个用户的时隙数量
queueLength= 500;      % 各节点队列长度
Tmax = 12000;          % 仿真时隙数

data(maxUser) = struct('delayAver', [], 'deliveryRate', [], 'averageThroughput', [], 'slotUtilization', []);

for numUsers=1:maxUser

    numUsers
    lambda = zeros(1,numUsers);          % 泊松分布的到达率（λ），即平均每个时隙到达的数据包
    SlotTable = zeros(2,numUsers);       %时隙表
    % 统计变量
    ArrivalInt=1;%数据包到达率编号
    delayAver=zeros(1,100);
    deliveryRate=zeros(1,100);% 分组投递率
    averageThroughput=zeros(1,100);% 平均吞吐量
    slotUtilization=zeros(1,100);%时隙利用率

    
    % 初始化时隙表
    for i=1:numUsers
        SlotTable(1,i)=(i-1)*slotaverage+1;
        SlotTable(2,i)=i*slotaverage;
    end


    starttime=0;
    endtime=0.15;
    step=0.01;
    for rate=starttime:step:endtime%枚举数据包到达率，即平均每个时隙产生ArrivalTime个数据包
        for j=1:numUsers
            lambda(1,j)=rate;
        end

        % 初始化数据队列
        UserInfoList = Initialize(numUsers,queueLength);
        % 统计变量
        totNum=0;
        numsSent=0;
        packetSent=zeros(2,1000000);
        sendrop = zeros(1,2);

        for t = 1:Tmax
            %每个超帧开头生成整个超帧到达数据
            if(mod(t,numSlots)==1)
                user=1;%当前处于第几个用户服务时间
                slotindex=1;%当前时隙为超帧中第几个时隙
                [UserInfoList,sendrop,totNum]=generateNewPacket(t,UserInfoList,queueLength,numUsers,numSlots,sendrop,lambda,totNum);
                SlotTable=changeSlot(SlotTable,UserInfoList,numSlots,numUsers,totNum);
            end
            if(user>numUsers)
                continue;
            end
            %每个时隙判断是否发送
            if(slotindex<=SlotTable(2,user))
                %若该节点有数据则发送
                if(UserInfoList(user).packetNum~=0 && t>=UserInfoList(user).packets(1,1))
                    totNum=totNum-1;
                    numsSent=numsSent+1;
                    sendrop(1,2)=sendrop(1,2)+1;
                    UserInfoList(user).packets(2,1)=t;%设置当前发送时间
                    packetSent(:,numsSent)=UserInfoList(user).packets(:,1);
                    UserInfoList(user).packets=[UserInfoList(user).packets(:,2:queueLength) zeros(2,1)] ;%将第一个数据包移除
                    UserInfoList(user).packetNum=UserInfoList(user).packetNum-1;
                end
            end
            %当前节点最后一个时隙，则更新节点
            if(slotindex==SlotTable(2,user))
                user=user+1;
            end

            slotindex=slotindex+1;
        end

        % 平均时延
        delay=0;
        for i=1:numsSent
            delay=delay+packetSent(2,i)-packetSent(1,i);
        end
        delayAver(1,ArrivalInt)=delta*delay/numsSent;
        % 分组投递率
        deliveryRate(1,ArrivalInt)=sendrop(1,2)/sendrop(1,1);
        % 平均吞吐量
        averageThroughput(1,ArrivalInt)=numsSent*PacketLength/(delta*(Tmax-numSlots));
        %时隙利用率
        slotUtilization(1,ArrivalInt)=numsSent/Tmax;

        ArrivalInt=ArrivalInt+1;
    end
    
    data(numUsers).delayAver=delayAver;
    data(numUsers).deliveryRate=deliveryRate;
    data(numUsers).averageThroughput=averageThroughput;
    data(numUsers).slotUtilization=slotUtilization;
    
end
save('dynamictdma.mat');


