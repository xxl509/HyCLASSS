function  [C0_average]=c0complex(A,Fs,window_t,p) 
%clear;clc;

%A=load(input);
M=length(A);
%Fs=256;
%window_t=60; % 4s
N=Fs*window_t;%每次计算的序列长度
m=N; %30*Fs;%每次滑动的点数 2s
r=5;
%有重叠的部分时 使用t=((M-N)/m);
t = M/m;
h=floor(t);

ij = 1;
i = 1;
dek = 0;
while i <= h %滑动的次数
%      if (i ~= 0)&& (mod(i-dek,29)==0)
%         i = i + 1;
%         dek = dek + 1;
%     end
    data=A(1+(i-1)*m:i*m);%数据滑动读取
    Fn=fft(data,N);      %对序列做FFT
    Fn_1=zeros(size(Fn));
    Gsum=0;
    for j=1:N
        Gsum=Gsum+abs(Fn(j))*abs(Fn(j));
    end
        Gave=(1/N)*Gsum; %求序列的均方值
    for j=1:N
        if abs(Fn(j))*abs(Fn(j))>(r*Gave) %求取序列的规则部分的频谱
           Fn_1(j)=Fn(j);
        end
    end
    data1=ifft(Fn_1,N);%求取序列的规则部分
    D=(abs(data(1:N)-data1)).^2;%求取序列的随机部分
    Cu=sum(D);%序列随机部分的面积
    E=(abs(data(1:N))).^2;
    Cx=sum(E);%序列的面积
    C0(ij)=Cu/Cx; %C0复杂度
    ij = ij + 1;
    i = i + 1;
end  
if p==1
   plot(C0);
end
    %filename='C:\Documents and Settings\Administrator\桌面\实验10-04-19\c0\slp04\83swsac0.txt';
    
    %%取C0的平均值
    C0_average=sum(C0)/(ij-1);



