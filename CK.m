function Ckm=CK(data,m,N,tau)
ss=20;
C=zeros(1,ss);
M=N-(m-1)*tau;%��ռ�ÿһά���еĳ���
d=zeros(M-1,M);
Y=reconstitution(data,N,m,tau);%�ع���ռ�
min_d=10000;
for i=1:M-1
    for j=i+1:M
        d(i,j)=norm((Y(:,i)-Y(:,j)),2);
        if d(i,j)<min_d
            min_d=d(i,j);%�õ����е�����̾���
        end
    end     %����״̬�ռ���ÿ����֮��ľ���
end
max_d=max(max(d));% �õ����е�֮���������
% min_d=min(min(d));
delt=(max_d-min_d)/ss;% �õ�r�Ĳ���
%for k=1:ss
r=min_d+7*delt;
H=length(find(r>d))';
C=2*H/(M*(M-1));
Ckm=C-1;
%end