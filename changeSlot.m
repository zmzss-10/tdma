function SlotTable=changeSlot(SlotTable,UserInfoList,numSlots,numUsers,totNum)
    %若每个节点均满足发送，则不修改
    remainslots=numSlots;
    needchange=0;
    newslot=zeros(1,numUsers);
    for user=1:numUsers
        availableSlots=SlotTable(2,user)-SlotTable(1,user)+1;
        %超出负载需要申请变换
        if(UserInfoList(user).packetNum>availableSlots)
            needchange=needchange+1;
        end
        slotAllocation =floor(numSlots*UserInfoList(1).packetNum/totNum);
        if(slotAllocation==0)
            slotAllocation=1;
        end
        newslot(1,user)=slotAllocation;
        remainslots=remainslots-newslot(1,user);
    end
    while(remainslots>0)
        % 找到当前时隙分配最少的节点
        [~, idx] = min(newslot);
        newslot(1,idx) = newslot(1,idx) + 1; % 增加一个时隙
        remainslots = remainslots - 1; % 减少剩余时隙
    end
    
    %进行修改
%     if(needchange>0.3*numUsers && needchange<0.7*numUsers) 
    if(needchange>0.3*numUsers) 
         SlotTable(1,1)=1;
         SlotTable(2,1)=newslot(1,1);
        for i=2:numUsers
            SlotTable(1,i)=SlotTable(2,i-1)+1;
            SlotTable(2,i)=SlotTable(2,i-1)+newslot(1,i);
        end
    end
end
