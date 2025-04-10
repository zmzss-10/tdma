function UserInfoList = Initialize(numUsers,queueLength)
for i=1:numUsers
    UserInfoList(i).packetNum=0;%第i个节点待发送的数据包总数
    UserInfoList(i).packets=zeros(2,queueLength);%各个包的信息第一行为到达时间，第二行为实际发送时间，超过队列的数据包丢弃
end

