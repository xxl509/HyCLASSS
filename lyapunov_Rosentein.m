
function [M_lya]=lyapunov_Rosentein(A,fs,window_t,winIndex)
% Original : function [lambda_1,M_lya]=lyapunov_Rosentein(A,fs)
% filename='F:\data\biyeshuju\slp14\wake\1.txt';
%A=load(input);
%Fs=256;
% window_t=20;

N=fs*window_t;
m=15;                %嵌入维数
%tau=tau_def(data,N);%时间延迟
delt_t=1/fs;    %采样间隔
G=length(A);
g=fs*window_t; % g=fs*2;%每次滑动的点数
t=((G-N)/g);
h=floor(t);
for ii=0:h%滑动的次数
    data=A(1+ii*g:N+ii*g);
    if length(unique(data)) <= 5
        lambda_1 = NaN;
        continue;
    end
    tau=tau_def(data);%时间延迟
    
    P=period(data); %序列的平均周期
    try
        Y=reconstitution(data,N,m,tau);%相空间重构
    catch
        disp('ERROR..in LYA');
    end
    M=N-(m-1)*tau;       %重构相空间中相点的个数
    for j=1:M           %寻找相空间中每个点的最近距离点
        d_min=1.0e+15;
        for jj=1:M
            if abs(j-jj)>P %限制短暂分离
                d_s(j,jj)=norm((Y(:,j)-Y(:,jj)),2);
                if d_s(j,jj)<d_min
                    d_min=d_s(j,jj);
                    idx_j=jj;     %记下相空间中每个点的最近距离点的下标
                end
            end
        end
        index(j)=idx_j;
        imax=min((M-j),(M-idx_j));%计算点j的最大演化时间步长i
        for i=1:imax
            d_j_i=0;
            d_j_i=norm((Y(:,j+i)-Y(:,idx_j+i)),2);   %计算点j与其最近邻点在i个离散步后的距离
            d(i,j)=d_j_i;     %生成i*j列矩阵
        end
    end
    %对每个演化时间步长i，求所有的j的lnd(i,j)平均
    [l_i,l_j]=size(d);
    for i=1:l_i
        q=0;
        y_s=0;
        for j=1:l_j
            if d(i,j)~=0
                q=q+1; %计算非零的d(i,j)的数目
                y_s=y_s+log(d(i,j));
            end
        end
        y(i)=y_s/(q*delt_t);%对每个i求出所有的j的lnd(i,j)平均
    end
    x=1:length(y);
    % plot(x,y,'-o');
    %  xlabel('x');
    %  ylabel('y');
    linearzone=[20:80];
    Lya=polyfit(x(linearzone),y(linearzone),1);
    % hold on;
    lambda_1(ii+1)=Lya(1);
    % filename ='F:\data\biyeshuju\slp14\wake\ly.txt';
end

M_lya=mean(lambda_1);
if ~mod(winIndex,400)
    fprintf('%d ',winIndex);
end




