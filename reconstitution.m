function X=reconstitution(data,N,m,tau)
%该函数用来重构相空间
% m为嵌入空间维数
% tau为时间延迟
% data为输入时间序列
% N为时间序列长度
% X为输出,是m*M维矩阵

M=N-(m-1)*tau;%相空间中点的个数
if isempty(M)
    X = [];
else
    for  j=1:M       %相空间重构
        for i=1:m
            X(i,j)=data((i-1)*tau+j);
        end
    end
end