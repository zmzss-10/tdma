%   �����µ����ݰ�
function [UserInfoList,sendrop,totNum] = generateNewPacket(t,UserInfoList,queueLength,numUsers,numSlots,sendrop,lambda,totNum)
    % �������ÿ���û���ÿ��ʱ϶����İ�
    for i = 1:numUsers
        for slot = 1:numSlots
            numArrivals = poissrnd(lambda(1,i)); % ÿ��ʱ϶��������ݰ���
            % �����������
            if(UserInfoList(i).packetNum>=queueLength)
                sendrop(1,1)=sendrop(1,1)+numArrivals;
                continue;
            end
            % �û��ڸ�ʱ϶�а�����
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
   
