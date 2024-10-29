function  [Kmean]=kolmgolov_entropy(A,Fs,window_t,p,winIndex)

% window_t=60; %4
N=Fs*window_t;%每次计算的序列长度
tau=6;
m=15;
G=length(A);
g=N; %Fs*(window_t/2);%每次滑动的点数
%t=((G-N)/g);
t = G/g;
h=floor(t);
LKm=zeros(h,1);
ij = 1;
i = 1;
dek = 0;
while i <= h %滑动的次数
    %     if (i ~= 0)&& (mod(i-dek,29)==0)
    %         i = i + 1;
    %         dek = dek + 1;
    %     end
    data=A(1+(i-1)*g:i*g);
%     if length(unique(data)) <= 5
%         Km = NaN;
%         continue;
%     end
    LCK=CK(data,m+13,N,tau);
    if LCK==0
        LCK=1;
        LKm(ij)=log(LCK)./LCK;
    else
        LKm(ij)=log((CK(data,m,N,tau))./(CK(data,m+13,N,tau)));
    end
    Km=(1/(tau*13))*LKm;
%     disp(['kolmgolov of ', num2str(i)]);
    ij = ij + 1;
    i = i + 1;
    %Ke=Km(3);
    
end
if p==1
    plot(Km);
end
Km = Km(1:length(find(Km ~= 0)),:);
Kmean=mean(Km);
if ~mod(winIndex,400)
    fprintf('%d ', winIndex);

end
