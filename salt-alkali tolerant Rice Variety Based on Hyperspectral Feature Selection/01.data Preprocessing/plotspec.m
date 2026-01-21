function [Y] = plotspec(Xi,spectra,i,str,FigureSave)
% Xi - 波长数值
% spectra - 光谱数据
% i - 第i个图窗
% str - 标签
% FigureSave - 保存图片文件夹
figure(i)
plot(Xi,spectra);
xlim([min(Xi) max(Xi)])  % 波长范围，也可直接设置波长最大最小值
title(str(i)); % 1.原始光谱
xlabel('Wavelength/nm');    % x轴标签，波长
ylabel('Reflectance');    % y轴标签，反射系数
set(gca,'FontName','Times New Roman')   % 设置窗口字体为 “Times New Roman”
savefig(gcf,fullfile(FigureSave ,str(i)))    % 可保存为fig格式，方便后续图窗属性修改
print(gcf,'-dpng','-r600',fullfile(FigureSave ,str(i)))
Y=11;   % 为保持函数完整，无实际意义，无需修改
end