%   生成新的数据包
function [UserInfoList,sendrop,totNum] = generateNewPacket(t,UserInfoList,queueLength,numUsers,numSlots,sendrop,lambda,totNum)
    % 随机生成每个用户在每个时隙到达的包
    for i = 1:numUsers
        for slot = 1:numSlots
            numArrivals = poissrnd(lambda(1,i)); % 每个时隙到达的数据包数
            % 缓存队列已满
            if(UserInfoList(i).packetNum>=queueLength)
                sendrop(1,1)=sendrop(1,1)+numArrivals;
                continue;
            end
            % 用户在该时隙有包到达
            if(numArrivals > 0) 
                sendrop(1,1)=sendrop(1,1)+numArrivals;
                while(numArrivals>0 && UserInfoList(i).packetNum<queueLength)
                    totNum=totNum+1;
                    UserInfoList(i).packetNum=UserInfoList(i).packetNum+1;                    
                    UserInfoList(i).packets(1,UserInfoList(i).packetNum)=t+slot-1;
                    numArrivals=numArrivals-1;
                end
            end
        end
    end
end
   
