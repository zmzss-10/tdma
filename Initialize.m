function UserInfoList = Initialize(numUsers,queueLength)
for i=1:numUsers
    UserInfoList(i).packetNum=0;%��i���ڵ�����͵����ݰ�����
    UserInfoList(i).packets=zeros(2,queueLength);%����������Ϣ��һ��Ϊ����ʱ�䣬�ڶ���Ϊʵ�ʷ���ʱ�䣬�������е����ݰ�����
end

