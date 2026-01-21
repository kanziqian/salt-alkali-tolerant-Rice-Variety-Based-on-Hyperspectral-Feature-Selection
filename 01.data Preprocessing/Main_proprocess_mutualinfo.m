%% Ⅰ清空变量环境
warning off             % 关闭警告
close all               % 关闭图窗
clear                   % 清空工作区
clc                     % 清空命令行窗口
%% Ⅱ导入数据
data = xlsread('合并数据.xlsx',1) ;   % 参数1是指sheet1
%% 剔除数据350-400,2400-2500
data(:,2401-349:2500-349)=[];
data(:,350-349:399-349)=[];
Xi=data(1,1:end-1);   % 提取波长数值
refle=data(2:end,1:end-1);  % 提取光谱数据
Y=data(2:end,end);   % 提取指标含量或分类标签
spectra = refle;   % 0.原始数据(RAW)

%% Ⅲ数据预处理
%--------------------------------尺度缩放-----------------------------------
% 1.离差标准化（MMS）
spectra_MMS = MMS(spectra);   % 调用 “MMS” 函数文件
% 2.均值中心化(Centered)
spectra_MCX = center(spectra);   % 调用 “MMS” 函数文件
% 3.Z-Score标准化
spectra_auto = auto(spectra);   % 调用 “auto” 函数文件
% 4.Pareto尺度化
spectra_Pareto = pareto(spectra);   % 调用 “pareto” 函数文件
% 5.normalize规范化
spectra_Nor= normaliz(spectra);   % 调用 “normaliz” 函数文件
%--------------------------------平滑降噪-----------------------------------
% 6.移动平均窗口平滑(Average moving)****
spectra_am=average_moving(spectra,9);   % 调用 “average_moving” 函数文件，后面的参数为窗宽，必须为奇数
% 7.S-G卷积平滑(SG)****
spectra_sg = sg_smooth(spectra,5,7);   % 调用 “sg_smooth” 函数文件，第二个参数为拟合次数，最后一个参数是窗口数，必须为奇数
%--------------------------------散射校正-----------------------------------
% 8.多元散射校正(MSC)
spectra_msc=MSC(spectra);   % 调用 “MSC” 函数文件
% 9.标准正态变量变换(SNV)
spectra_snv=SNV(spectra);   % 调用 “SNV” 函数文件
%--------------------------------基线校正-----------------------------------
% 10.一阶微分(FD)
spectra_deriv1=deriv(spectra,1);   % 调用 “deriv” 函数文件，后面的参数设置为1
% 11.二阶微分(SD)
spectra_deriv2=deriv(spectra,2);   % 调用 “deriv” 函数文件，后面的参数设置为2
% 12.去趋势处理(Detrend)
spectra_xdetrend=detrend(spectra);   % 调用 “detrend” 函数文件
%----------------------------------组合-------------------------------------
% 13.S-G卷积平滑+一阶微分FD（作用：平滑+基线校正）
sg_deriv1=deriv(spectra_sg,1);   % 先做卷积平滑，再做一阶微分
% 14.S-G卷积平滑+二阶微分SD（作用：平滑+基线校正）
sg_deriv2=deriv(spectra_sg,2);   % 先做卷积平滑，再做二阶微分
% 15.S-G卷积平滑+多元散射校正(MSC)（作用：平滑+散射校正）
sg_msc=MSC(spectra_sg);   % 先做卷积平滑，再做多元散射校正
% 16.标准正态变量变换(SNV)+一阶微分FD（作用：散射校正+基线校正）
snv_deriv1=deriv(spectra_snv,1);   % 先做标准正态变量变换，再做一阶微分
% 17.标准正态变量变换(SNV)+二阶微分SD（作用：散射校正+基线校正）
snv_deriv2=deriv(spectra_snv,2);   % 先做标准正态变量变换，再做二阶微分
% 18.标准正态变量变换(SNV)+去趋势处理detrend（作用：散射校正+尺度规范）
snv_xdetrend=detrend(spectra_snv);   % 先做标准正态变量变换，再做去趋势处理
% 19.移动平均窗口平滑(am)+离差标准化（MMS）（作用：平滑+尺度规范）
am_MMS = MMS(spectra_am);   % 先做移动平均窗口平滑，再做离差标准化
% 20.移动平均窗口平滑(am)+均值中心化（center）（作用：平滑+尺度规范）
am_MCX = center(spectra_am);   % 先做移动平均窗口平滑，再做均值中心化
% 21.移动平均窗口平滑(am)+Pareto尺度化（作用：平滑+基线校正）
am_Pareto = pareto(spectra_am);   % 先做移动平均窗口平滑，再做Pareto尺度化
%% Ⅳ相关性分析及绘图
FigureSave = fullfile('结果图');   % 光谱处理图片保存至“结果图”文件夹中
mkdir(FigureSave)    % 创建文件夹
str = ["RAW" "MMS" "Centered" "Z-Score" "Parato" "normalize"...
    "Average Moving" "SG" "MSC" "SNV" "FD" "SD" "Detrend" "SG+FD"...
    "SG+SD" "SG+MSC" "SNV+FD" "SNV+SD" "SNV+Detrend" "AM+MMS"...
    "AM+Center" "AM+Pareto"];
polt_save={spectra;spectra_MMS;spectra_MCX;spectra_auto;spectra_Pareto;...
    spectra_Nor;spectra_am;spectra_sg;spectra_msc;spectra_snv;...
    spectra_deriv1;spectra_deriv2;spectra_xdetrend;sg_deriv1;sg_deriv2;...
    sg_msc;snv_deriv1;snv_deriv2;snv_xdetrend;am_MMS;...
    am_MCX;am_Pareto};  % 各变换光谱数据
nn = size(polt_save,1);   % 共保存了nn个光谱数据
% 各预处理图
for ii=1:nn
    % f1=plotspec(Xi,polt_save{ii},ii,str,FigureSave);   % 绘制各变换光谱图
    refle_mutual=mutualinfo(polt_save{ii},Y);   % 计算各变换光谱与Y的相关系数
    corr_max(ii,:)=max(max(abs(refle_mutual)));   % 保存每条光谱与Y的最大相关系数
end
% 相关性绘图
figure
scatter(1:nn,corr_max,'filled')   % 绘制散点图
grid on;   % 打开底纹网格
set(gca,'FontName','Times New Roman','Xlim',[1 nn],'XTick',1:1:nn,'XTickLabel',str)   % 设置x轴刻度显示为文字
ylabel('\fontname{宋体}相关系数');
xlabel('\fontname{宋体}预处理方法');
xtickangle(45)  % 设置刻度文字显示方向
print(gcf,'-dpng','-r600','预处理相关系数')   % 保存为分辨率为600的PNG文件
corr_save = [corr_max,str'];   % 保存预处理数据相关系数最大值及各预处理名称
xlswrite('预处理数据相关系数最大值.xlsx',corr_save,1);   % 导出至Excel表格

%% Ⅴ保存数据
prspectra_save=[Xi,0;snv_deriv1,Y];   % 保存最优预处理数据及Y值
xlswrite('预处理后数据.xlsx',prspectra_save,1);   % 导出至Excel表格
