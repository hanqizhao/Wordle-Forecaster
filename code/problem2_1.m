clc,clear;
data1 = readmatrix('xvhao.xlsx');
data2 = readmatrix('pinci1.xlsx');
data3 = readmatrix('Problem_C_Data_Wordle.xlsx');
[m1,n1] = size(data1);
[m2,n2] = size(data2);
tezheng = zeros(m1-1,n1-1);
pinci = zeros(m2-1,n2-1);

time = data3(1:end,2);
y1 = data3(1:end,6);
y2 = data3(1:end,7);
y3 = data3(1:end,8);
y4 = data3(1:end,9);
y5 = data3(1:end,10);
y6 = data3(1:end,11);
y7 = data3(1:end,12);

for i = 1:m1-1
    for j = 1:n1-2
        tezheng(i,j) = data1(i+1,j+1);
    end
end

for i = 1:m2-1
    for j = 1:n2-1
        pinci(i,j) = data2(i+1,j+1);
    end
end

num = zeros(359,2);
for i = 1:359
    num(i,1) = pinci(i,1) + pinci(i,5) + pinci(i,9) + pinci(i,15) + pinci(i,21);
    num(i,2) = pinci(i,2) + pinci(i,3) + pinci(i,4) + pinci(i,6) + pinci(i,7)+...
        pinci(i,8) + pinci(i,10) + pinci(i,11) + pinci(i,12) + pinci(i,13) +...
        pinci(i,14) + pinci(i,16) + pinci(i,17) + pinci(i,18) + pinci(i,19) + pinci(i,20) +...
        pinci(i,22) + pinci(i,23) + pinci(i,24) + pinci(i,25) + pinci(i,26);
end

bili = zeros(359,1);
for i = 1:359
    bili(i,1) = num(i,1)/num(i,2); 
end

for i = 1:359
    tezheng(i,end) = bili(i,1); 
end

X = ones(359,7);  %特征值
for i = 1:359
    for j = 1:6
        X(i,j+1) = tezheng(i,j);
    end
end
[standard,ps] = mapstd(X);
loss = zeros(1,1000);
I = eye(7);
for i = 1:1000
    for j = 1:7
        lambda = i;
        model = inv(standard'*standard + lambda*I)*standard'*data3(1:end,j+5);
        y_pred = standard * model;
        loss(1,i) = mean((y_pred - data3(1:end,j+5)).^2) + loss(1,i);
    end
    loss(1,i) = loss(1,i)/7 ;
end
xvhao = min(loss);
lambda_opt = find(loss == xvhao);

%model_opt = inv(standard'*standard+lambda_opt*I)*standard'*y7;
%y1_forecast = standard*model_opt;
%plot(time,y7,'g',time,y1_forecast,'r');
%legend('actual value','forecast value');

for i = 1:7
    theta{i}= inv(standard'*standard+lambda_opt*I)*standard'*data3(1:end,i+5);
    y_forecast{i} = standard*theta{i}; 
end

word = [1,5,5,18,9,5,4];
for i = 1:7
    forecast(i) = word*theta{i};
end
sum = 0;
for i = 1:7
    sum = forecast(i) + sum ;
end
forecast = forecast/sum;

