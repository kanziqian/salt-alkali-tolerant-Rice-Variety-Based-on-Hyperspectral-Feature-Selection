
%% 清空环境变量
clear; clc; close all;

%% 导入数据

data = xlsread('光谱指数整合数据 _按耐盐性排序.xlsx', 1);

%% 参数设置

n_features = 33;     % 特征数量n_features = 33;

n_classes = 12;       % 类别数量
feature_names = arrayfun(@(x) sprintf('F%d', x), 1:n_features, 'UniformOutput', false);
class_names = {'Class 1', 'Class 2', 'Class 3', 'Class 4','Class 5','Class 6','Class 7','Class 8',...
    'Class 9','Class 10','Class 11','Class 12'};

%% 计算每个类别的特征均值和标准差
class_means = zeros(n_classes, n_features);
class_stds = zeros(n_classes, n_features);

for c = 1:n_classes
    class_data = data(data(:, end) == c, 1:end-1);
    class_means(c, :) = mean(class_data, 1);
    class_stds(c, :) = std(class_data, 0, 1);
end

%% 数据标准化（使所有特征在[0,1]范围）
% min_vals = min(class_means, [], 1);
% max_vals = max(class_means, [], 1);
% scaled_means = (class_means - min_vals) ./ (max_vals - min_vals);
% scaled_stds = class_stds ./ (max_vals - min_vals); % 相对标准差


%% 保存统计表格（可选）
% 创建数据表格显示原始均值和标准差
% t = uitable('Data', num2cell([class_means, class_stds]), ...
%             'ColumnName', [arrayfun(@(x) sprintf('Mean F%d', x), 1:n_features, 'un', 0), ...
%                           arrayfun(@(x) sprintf('Std F%d', x), 1:n_features, 'un', 0)], ...
%             'RowName', class_names, ...
%             'Position', [50, 50, 1100, 100], ...
%             'FontSize', 9);


%%
combined_table_sci = table();
for f = 1:n_features
    combined_values = arrayfun(@(c) sprintf('(%.2f ± %.2f)', ...
        class_means(c, f), class_stds(c, f)), ...
        1:n_classes, 'UniformOutput', false)';
    combined_table_sci.(feature_names{f}) = combined_values;
end
combined_table_sci.Properties.RowNames = class_names;

% 将表格转换为单元格数组
output_cell = table2cell(combined_table_sci);

% 确保class_names是列向量（n_classes×1）
if isrow(class_names)
    class_names = class_names';
end

% 添加表头(列名)
headers = [{'类别'}, feature_names];

% 构建完整输出（注意转置处理）
full_output = [headers; 
               class_names, output_cell]; % 自动广播

% 写入Excel
xlswrite('特征统计参数.xlsx', full_output, 1);