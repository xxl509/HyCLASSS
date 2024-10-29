function [Average_PSen]=spectral_entropy(A,Fs,window_t,p)
%original function [PSen,Average_PSen]=spectral_entropy(A,Fs,p)
%A=load(input);
M=length(A);
% window_t= 60; %4
N=  Fs*window_t;%ÿ�μ�������г���
m=Fs*window_t; %Fs*30;%ÿ�λ����ĵ���
%t=((M-N)/m);
t=(M/m);
h=floor(t);
ij = 1;
j = 1;
dek = 0;
while j <= h %�����Ĵ���
    %     if (j ~= 0)&& (mod(j-dek,29)==0)
    %         j = j + 1;
    %         dek = dek + 1;
    %     end
    Xt=A(1+(j-1)*m:j*m); %Xt ��ʾһ��ʱ��γ���
    Pxx = abs(fft(Xt,N)).^2/N;                 %��ȡ�������ܶ�
    Spxx=sum(Pxx(2:1+N/2));                    %��ȡʱ�����е��ܹ���
    Pf=(Pxx(2:1+N/2))./Spxx;                            %��ȡ����
    for i=1:N/2
        if Pf(i)~=0
            LPf(i)=log(Pf(i));                %��ȡ��������
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
Average_PSen=mean(PSen);  %AveragePSen��һ��ֵ


