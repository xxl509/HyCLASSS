function P=period(data)
F=fft(data) ;           %����FFT�任
N=length(F);            %FFT�任�����ݳ���
%Y(1)=[];                %ȥ��Y�ĵ�һ�����ݣ������������ݵĺ�
for i=1:N
    f(i)=(2*pi)*((i-1)/N);
end
for i=2:N
    aver_P(i)=((abs(F(i)))*(abs(F(i))))./f(i);
    aver_TP(i)=(abs(F(i)))*(abs(F(i)));
end
P_value=(sum(aver_P))/(sum(aver_TP));
if P_value<=100
    P=P_value;
else
    P=100;
end
% for i=1:N
%     f(i)=i/N;
% end
% plot(f,abs(Y));
% Y1=abs(Y);
% [a,b]=max(Y1(1:N));
% P=1/f(b);


% power = log(real(Y).^2+imag(Y).^2);%������
% freqave=power/(N/Fs);
% P=freqave;       %���±����ƽ������

% Y=fft(data) ;           %����FFT�任
% N=length(Y);            %FFT�任�����ݳ���
% Y(1)=[];                %ȥ��Y�ĵ�һ�����ݣ������������ݵĺ�
% power = log(real(Y).^2+imag(Y).^2);%������
% nyquist=1/2;
% freq=(1:N/2)/(N/2)*nyquist;%��Ƶ��
% [mp,index] = max(power);  %�������������Ӧ���±�    
% freqave=freq(index);
% P=1/freqave;       %���±����ƽ������
