clc,clear;
raw = xlsread('Problem_C_Data_Wordle1.xlsx');
a = raw(1:end,4);
date = raw(1:end,1);
n = length(a);
num_par = zeros(1,n);
temp = zeros(1,n);
alpha = 0.5;

for i = 0:n-1
    num_par(i+1) = a(n-i);
end

for i = 0:n-1
    temp(i+1) = date(n-i);
end

datenn = datenum(temp);
beta = 0.2;
behind_par = num_par(1:end);
ft0 = mean(behind_par(1:3)) ;
ft1(1) = beta*behind_par(1) + (1-beta)*ft0;
ft2(1) = beta*ft1(1) + (1-beta)*ft0;
ft3(1) = beta*ft2(1) + (1-beta)*ft0;
for k = 1:300
    for i = 2:n
        ft1(i) = beta*behind_par(i) + (1-beta)*ft1(i-1);
        ft2(i) = beta*ft1(i) + (1-beta)*ft2(i-1);
        ft3(i) = beta*ft2(i) + (1-beta)*ft3(i-1);
    end
    at2{k} = 3*ft1 -3*ft2 +ft3;
    bt2{k} = 0.5*beta/(1-beta)^2*((6-5*beta)*ft1 - 2*(5-4*beta)*ft2 +(4-3*beta)*ft3);
    ct{k} = 0.5*beta^2/(1-beta)^2*(ft1 - 2*ft2+ft3);
    yat2{k} = at2{k}+bt2{k}+ct{k};
    error1(k) = sqrt(mean((yat2{k} - behind_par).^2));
    beta = beta + 0.001;
end
figure;
plot(1:300,error1,'r');
loss2_min = min(error1);
xvhao2 = find(error1 == loss2_min);
figure;
plot(1:356,yat2{xvhao2},'b',1:356,behind_par,'r');
legend('forecast value','actual value');
beta1 = 0.2 + (xvhao2-1)*0.001;
xishu = [ct{xvhao2}(end),bt2{xvhao2}(end),at2{xvhao2}(end)];
forecast(1) = polyval(xishu,60);


