clc,clear;
data = readmatrix('Problem_C_Data_Wordle.xlsx');
percentage = zeros(359,8);

for i = 1:359
    for j = 1:7
        percentage(i,j) = data(i,j+5);
    end
    for j = 1:7
        percentage(i,8) = percentage(i,8) + percentage(i,j);    %求和
    end
    for j = 1:7
        percentage(i,j) = percentage(i,j)/percentage(i,8);      %归一化
    end
end

sum_six_seven = 0;
for i = 1:359
    for j = 6:7
        sum_six_seven = sum_six_seven +percentage(i,j);
    end
end
pinjun = sum_six_seven/359;
for i = 1:359
    pinjunzhi(i) = (percentage(i,6) + percentage(i,7))/pinjun;
end
zuida = max(pinjunzhi) ;
pinjunzhi1 = pinjunzhi;
pinjunzhi = pinjunzhi/zuida;

%求元音辅音比
data1 = readmatrix('pinci1.xlsx');
[m2,n2] = size(data1);
pinci = zeros(m2-1,n2-1);
for i = 1:m2-1
    for j = 1:n2-1
        pinci(i,j) = data1(i+1,j+1);
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

%最小频率
%求各个字母出现频数
every_zimu = zeros(1,26);
for i = 1:26
    for j = 1:359
        every_zimu(1,i) = every_zimu(1,i) + pinci(j,i);
    end
end

%求总字母数
sum_zimu = 0;
for i = 1:359
    for j = 1:26
        sum_zimu = sum_zimu + pinci(i,j);
    end
end

%各个字母频率
pinlv_zimu = every_zimu/sum_zimu;

%最小频率
min_pinlv = zeros(359,1);
word_pinlv = ones(1,5);        %存储字母频率
k = 1;
for i = 1:359
    for j = 1:26
        if pinci(i,j) >= 1
            word_pinlv(1,k) = pinlv_zimu(1,j);
            k = k+1;        
        end
    end
    min_pinlv(i,1) = min(word_pinlv);
    k = 1;
end

%平均频率
he = sum(pinci,2);
pinjun_pinlv = zeros(359,1);
for i = 1:359
    pinjun_pinlv(i,1) = pinci(i,:)* pinlv_zimu'/he(i);
end

%最大重复字母数
max_chong = zeros(359,1);
for i = 1:359
    max_chong(i,1) = max(pinci(i,:));
end

x0 = ones(359,1);
%最后特征矩阵
final_X = [bili,min_pinlv,pinjun_pinlv,max_chong];
final_X = mapstd(final_X) ;
final_X = [x0,final_X];

%拟合
%BP神经网络
net = newff(final_X',pinjunzhi,[5 1],{'tansig','logsig'}, 'trainlm');%隐含层5个神经元，输出层1个神经元
net.trainParam.epochs = 10000; %训练的最大次数
net.trainParam.goal = 1e-5; %全局最小误差
net.trainParam.lr = 0.01;

net = train(net,final_X',pinjunzhi); 
O = sim(net,final_X'); %仿真模拟
%figure;
%plot(final_X,pinjunzhi,final_X,O,'r'); %绘制训练后得到的结果和误差曲线
%legend('原始数据','仿真数据')
V = net.iw{1,1}%输入层到中间层权值
theta1 = net.b{1}%中间层各神经元阈值
W = net.lw{2,1}%中间层到输出层权值
theta2 = net.b{2}%输出层各神经元阈值

%x1 = [1;4;0.0563;0.0877;3];
%x1 = [0.25;0.0307;0.0324;3];
x1 = [0.25;0.0301;0.0463;2];
x1 = mapstd(x1);
x1 = [1;x1];
x2 = V'*x1;
y= 1 ./ (1 + exp(-x2));

y = [1;y];
y1 = W*y;
y2= 1 ./ (1 + exp(-y1));
y3 = y2*zuida;


 

