function X=reconstitution(data,N,m,tau)
%�ú��������ع���ռ�
% mΪǶ��ռ�ά��
% tauΪʱ���ӳ�
% dataΪ����ʱ������
% NΪʱ�����г���
% XΪ���,��m*Mά����

M=N-(m-1)*tau;%��ռ��е�ĸ���
if isempty(M)
    X = [];
else
    for  j=1:M       %��ռ��ع�
        for i=1:m
            X(i,j)=data((i-1)*tau+j);
        end
    end
end