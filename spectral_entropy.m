function [Average_PSen]=spectral_entropy(A,Fs,window_t,p)
%original function [PSen,Average_PSen]=spectral_entropy(A,Fs,p)
%A=load(input);
M=length(A);
% window_t= 60; %4
N=  Fs*window_t;%每次计算的序列长度
m=Fs*window_t; %Fs*30;%每次滑动的点数
%t=((M-N)/m);
t=(M/m);
h=floor(t);
ij = 1;
j = 1;
dek = 0;
while j <= h %滑动的次数
    %     if (j ~= 0)&& (mod(j-dek,29)==0)
    %         j = j + 1;
    %         dek = dek + 1;
    %     end
    Xt=A(1+(j-1)*m:j*m); %Xt 表示一个时间段长度
    Pxx = abs(fft(Xt,N)).^2/N;                 %求取功率谱密度
    Spxx=sum(Pxx(2:1+N/2));                    %求取时间序列的总功率
    Pf=(Pxx(2:1+N/2))./Spxx;                            %求取概率
    for i=1:N/2
        if Pf(i)~=0
            LPf(i)=log(Pf(i));                %求取功率谱熵
        else
            LPf(i)=0;
        end
    end
    try
        Hf=Pf.*LPf';
    catch
        Hf=Pf.*LPf;
    end
    PSen(ij)=-(sum(Hf));
    ij = ij + 1;
    j = j+1;
end
if p==1
    plot(PSen);
end
Average_PSen=mean(PSen);  %AveragePSen是一个值


