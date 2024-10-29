function tau_value=tau_def(data)
A_ave=mean(data);   %需序列的均值
%A_std=std(data);%序列的标准差
N=length(data);
D=0;
E=0;
for t=1:1000 %用自相关法计算tau
    for i=1:N-t
        D=D+(data(i)-A_ave)*(data(i+t)-A_ave);
        E=E+(data(i)-A_ave)*(data(i)-A_ave);
    end
    C(t)=D/E;
    if C(t)<=0.65;%0.65=1-1/e
        tau_F=t;
        %    [a,b]=min(dif_C);
        %disp(t);
        break
    end
end
if ~exist('tau_F')
    tau_F = [];
end
if tau_F<=20
    tau_value = tau_F;
elseif tau_F > 20
    tau_value = 20;
elseif isempty(tau_F)
    tau_value = tau_F;
    
    
end