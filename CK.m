function Ckm=CK(data,m,N,tau)
ss=20;
C=zeros(1,ss);
M=N-(m-1)*tau;%相空间每一维序列的长度
d=zeros(M-1,M);
Y=reconstitution(data,N,m,tau);%重构相空间
min_d=10000;
for i=1:M-1
    for j=i+1:M
        d(i,j)=norm((Y(:,i)-Y(:,j)),2);
        if d(i,j)<min_d
            min_d=d(i,j);%得到所有点间的最短距离
        end
    end     %计算状态空间中每两点之间的距离
end
max_d=max(max(d));% 得到所有点之间的最大距离
% min_d=min(min(d));
delt=(max_d-min_d)/ss;% 得到r的步长
%for k=1:ss
r=min_d+7*delt;
H=length(find(r>d))';
C=2*H/(M*(M-1));
Ckm=C-1;
%end