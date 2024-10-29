function [Average_ShEn]=shannon_entropy(A,Fs,window_t,p)
% function [ShEn,Average_ShEn]=shannon_entropy(A,Fs,p)
%A=load(input);
M=length(A);
% window_t=60; % 4s
N=Fs*window_t;%ÿ�μ�������г���
m=N; %Fs*(window_t/2);%ÿ�λ����ĵ���
r=0.1;
Bin=fix(N*r);
%t=((M-N)/m);
t = M/m;
h=floor(t);
ij = 1;
j = 1;
dek = 0;
while j <= h
    %     if (j ~= 0)&& (mod(j-dek,29)==0)
    %         j = j + 1;
    %         dek = dek + 1;
    %     end
    Xt=A(1+(j-1)*m:j*m);
    %     Sam=sum(abs(Xt));  %������ȵľ���ֵ
    %     P=abs(Xt)./Sam;   %�������
    Xt_max=max(Xt);
    Xt_min=min(Xt);
    delta_Xt=(Xt_max-Xt_min)/Bin;
    Xt_axis=fix((Xt-Xt_min)/delta_Xt)+1;
    histograms=unique(Xt_axis);
    [Point,K]=size(histograms);
    P_Xt=zeros(Point,1);
    for i=1:Point
        for k=1:N
            if histograms(i)==Xt_axis(k)
                P_Xt(i)=P_Xt(i)+1;
            end
        end
    end
    Pxt=P_Xt./N;
    ShEn(ij)=-sum(Pxt.*log(Pxt));
    ij = ij + 1;
    j = j + 1;
    %ShEn=H./Bin;
end
if p==1
    plot(ShEn);
end
Average_ShEn=mean(ShEn);

