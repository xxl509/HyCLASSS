
function [M_lya]=lyapunov_Rosentein(A,fs,window_t,winIndex)
% Original : function [lambda_1,M_lya]=lyapunov_Rosentein(A,fs)
% filename='F:\data\biyeshuju\slp14\wake\1.txt';
%A=load(input);
%Fs=256;
% window_t=20;

N=fs*window_t;
m=15;                %Ƕ��ά��
%tau=tau_def(data,N);%ʱ���ӳ�
delt_t=1/fs;    %�������
G=length(A);
g=fs*window_t; % g=fs*2;%ÿ�λ����ĵ���
t=((G-N)/g);
h=floor(t);
for ii=0:h%�����Ĵ���
    data=A(1+ii*g:N+ii*g);
    if length(unique(data)) <= 5
        lambda_1 = NaN;
        continue;
    end
    tau=tau_def(data);%ʱ���ӳ�
    
    P=period(data); %���е�ƽ������
    try
        Y=reconstitution(data,N,m,tau);%��ռ��ع�
    catch
        disp('ERROR..in LYA');
    end
    M=N-(m-1)*tau;       %�ع���ռ������ĸ���
    for j=1:M           %Ѱ����ռ���ÿ�������������
        d_min=1.0e+15;
        for jj=1:M
            if abs(j-jj)>P %���ƶ��ݷ���
                d_s(j,jj)=norm((Y(:,j)-Y(:,jj)),2);
                if d_s(j,jj)<d_min
                    d_min=d_s(j,jj);
                    idx_j=jj;     %������ռ���ÿ���������������±�
                end
            end
        end
        index(j)=idx_j;
        imax=min((M-j),(M-idx_j));%�����j������ݻ�ʱ�䲽��i
        for i=1:imax
            d_j_i=0;
            d_j_i=norm((Y(:,j+i)-Y(:,idx_j+i)),2);   %�����j��������ڵ���i����ɢ����ľ���
            d(i,j)=d_j_i;     %����i*j�о���
        end
    end
    %��ÿ���ݻ�ʱ�䲽��i�������е�j��lnd(i,j)ƽ��
    [l_i,l_j]=size(d);
    for i=1:l_i
        q=0;
        y_s=0;
        for j=1:l_j
            if d(i,j)~=0
                q=q+1; %��������d(i,j)����Ŀ
                y_s=y_s+log(d(i,j));
            end
        end
        y(i)=y_s/(q*delt_t);%��ÿ��i������е�j��lnd(i,j)ƽ��
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




