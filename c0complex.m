function  [C0_average]=c0complex(A,Fs,window_t,p) 
%clear;clc;

%A=load(input);
M=length(A);
%Fs=256;
%window_t=60; % 4s
N=Fs*window_t;%ÿ�μ�������г���
m=N; %30*Fs;%ÿ�λ����ĵ��� 2s
r=5;
%���ص��Ĳ���ʱ ʹ��t=((M-N)/m);
t = M/m;
h=floor(t);

ij = 1;
i = 1;
dek = 0;
while i <= h %�����Ĵ���
%      if (i ~= 0)&& (mod(i-dek,29)==0)
%         i = i + 1;
%         dek = dek + 1;
%     end
    data=A(1+(i-1)*m:i*m);%���ݻ�����ȡ
    Fn=fft(data,N);      %��������FFT
    Fn_1=zeros(size(Fn));
    Gsum=0;
    for j=1:N
        Gsum=Gsum+abs(Fn(j))*abs(Fn(j));
    end
        Gave=(1/N)*Gsum; %�����еľ���ֵ
    for j=1:N
        if abs(Fn(j))*abs(Fn(j))>(r*Gave) %��ȡ���еĹ��򲿷ֵ�Ƶ��
           Fn_1(j)=Fn(j);
        end
    end
    data1=ifft(Fn_1,N);%��ȡ���еĹ��򲿷�
    D=(abs(data(1:N)-data1)).^2;%��ȡ���е��������
    Cu=sum(D);%����������ֵ����
    E=(abs(data(1:N))).^2;
    Cx=sum(E);%���е����
    C0(ij)=Cu/Cx; %C0���Ӷ�
    ij = ij + 1;
    i = i + 1;
end  
if p==1
   plot(C0);
end
    %filename='C:\Documents and Settings\Administrator\����\ʵ��10-04-19\c0\slp04\83swsac0.txt';
    
    %%ȡC0��ƽ��ֵ
    C0_average=sum(C0)/(ij-1);



