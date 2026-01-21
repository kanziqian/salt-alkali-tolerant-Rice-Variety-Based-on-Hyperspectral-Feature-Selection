%-----------Feature Correlation Analysis--------------
%% Clear Environment Variables
clc; close all; clear; warning off;

%% Import Data
x = xlsread('光谱指数整合数据 _按耐盐性排序.xlsx', 1);
data = x(3:end, 1:end);

n_features = 33;     % Number of features

% -----------------------------------------------------------------------------
data_normalized = zeros(size(data, 1), n_features); % Pre-allocate memory

for i = 1:n_features
    % Calculate mean and standard deviation
    mu = mean(data(:, i));
    sigma = std(data(:, i));
    
    % Z-score normalization
    data_normalized(:, i) = (data(:, i) - mu) / sigma;
end

features = data_normalized(:, 1:end);
y = data(:, end);

%% Correlation Analysis
features_corr = corr(features, y);

%% Get Top 15 Most Correlated Features (adjustable)
[sorted_corr, sorted_idx] = sort(abs(features_corr), 'descend');
top10_idx = sorted_idx(1:min(15, length(sorted_idx)));
top10_corr = features_corr(top10_idx);

%% Save Results to Excel
result_table = table((1:length(top10_idx))', top10_idx, top10_corr, ...
    'VariableNames', {'Rank', 'Feature_Index', 'Correlation_Coefficient'});
writetable(result_table, 'Top15_Correlated_Features.xlsx');

%% Visualization - Create Aesthetic Figure
figure('Position', [100, 100, 1400, 800], 'Color', [0.95, 0.95, 0.95], ...
    'Name', 'Feature Correlation Analysis');

% Create English feature names with proper capitalization
feature_names = cell(1, 33);
feature_names{1} = 'λgp';
feature_names{2} = 'Rgp';
feature_names{3} = 'λrv';
feature_names{4} = 'Rrv';
feature_names{5} = 'λNIR';
feature_names{6} = 'RNIR';
feature_names{7} = 'λbb';
feature_names{8} = 'Mbb';
feature_names{9} = 'Abb';
feature_names{10} = 'λyb';
feature_names{11} = 'Myb';
feature_names{12} = 'Ayb';
feature_names{13} = 'λrb';
feature_names{14} = 'Mrb';
feature_names{15} = 'Arb';
feature_names{16} = 'Dh';
feature_names{17} = 'W_B';
feature_names{18} = 'P';
feature_names{19} = 'S';
feature_names{20} = 'Sl';
feature_names{21} = 'Sr';
feature_names{22} = 'V';
feature_names{23} = 'D_n';
feature_names{24} = 'BDR';
feature_names{25} = 'Dh2';
feature_names{26} = 'W_R';
feature_names{27} = 'P2';
feature_names{28} = 'S2';
feature_names{29} = 'Sl2';
feature_names{30} = 'Sr2';
feature_names{31} = 'V2';
feature_names{32} = 'D_n2';
feature_names{33} = 'BDR2';

% Create subplot layout
subplot(2, 1, 1);

% Plot bar chart with gradient color
bar_colors = parula(n_features);  % Use color gradient
for i = 1:n_features
    bar(i, features_corr(i), 'FaceColor', bar_colors(i, :), ...
        'EdgeColor', 'k', 'LineWidth', 0.5);
    hold on;
end

% Mark top 15 features with red markers
scatter(top10_idx, top10_corr, 120, 'r', 'filled', ...
    'MarkerEdgeColor', 'k', 'LineWidth', 1.5);

% Customize plot appearance
title(' ', ...                                     %标题头
    'FontSize', 16, 'FontWeight', 'bold', 'Color', [0.1, 0.1, 0.1]);
xlabel('Features Number', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('MRMR Score', 'FontSize', 12, 'FontWeight', 'bold');

% Set x-axis properties
set(gca, 'XTick', 1:n_features, 'XTickLabel', feature_names, ...
    'XTickLabelRotation', 45, 'FontSize', 9, ...
    'GridColor', [0.7, 0.7, 0.7], 'GridAlpha', 0.5, ...
    'LineWidth', 1.5, 'Box', 'on');

grid on;
grid minor;
xlim([0, n_features+1]);
ylim([min(features_corr)-0.1, max(features_corr)+0.1]);

% Add colorbar for feature gradient
colormap(parula);
colorbar('Ticks', [], 'Position', [0.92, 0.58, 0.015, 0.3]);
text(34.5, mean(ylim), 'Feature Gradient', 'Rotation', 90, ...
    'FontSize', 10, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

% Subplot 2: Top 15 Features Horizontal Bar Chart
subplot(2, 1, 2);

% Sort top features for better visualization
[top_corr_sorted, sort_idx] = sort(top10_corr, 'ascend');
top_idx_sorted = top10_idx(sort_idx);

% Create horizontal bar chart
barh(1:length(top_idx_sorted), top_corr_sorted, 'FaceColor', [0.2, 0.6, 0.8], ...
    'EdgeColor', 'k', 'LineWidth', 1);

% Customize appearance
title('Top 15 Correlated Features', ...
    'FontSize', 16, 'FontWeight', 'bold', 'Color', [0.1, 0.1, 0.1]);
xlabel('Correlation Coefficient', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Feature Index', 'FontSize', 12, 'FontWeight', 'bold');

% Add feature names as y-tick labels
set(gca, 'YTick', 1:length(top_idx_sorted), ...
    'YTickLabel', feature_names(top_idx_sorted), ...
    'FontSize', 10, 'LineWidth', 1.5, 'Box', 'on');

grid on;
grid minor;
xlim([min(top_corr_sorted)-0.1, max(top_corr_sorted)+0.1]);
ylim([0, length(top_idx_sorted)+1]);

% Add correlation coefficient values on bars
for i = 1:length(top_corr_sorted)
    if top_corr_sorted(i) >= 0
        text_x = top_corr_sorted(i) + 0.01;
        text_align = 'left';
    else
        text_x = top_corr_sorted(i) - 0.01;
        text_align = 'right';
    end
    text(text_x, i, sprintf('%.3f', top_corr_sorted(i)), ...
        'FontSize', 9, 'FontWeight', 'bold', ...
        'VerticalAlignment', 'middle', 'HorizontalAlignment', text_align);
end

% Adjust layout
set(gcf, 'Color', 'w');
tight_layout = get(gca, 'TightInset');
set(gca, 'Position', [tight_layout(1), tight_layout(2), ...
    0.95-tight_layout(1)-tight_layout(3), 0.45-tight_layout(2)-tight_layout(4)]);

% Save high-quality figure
exportgraphics(gcf, 'Feature_Correlation_Analysis.png', 'Resolution', 600);

% Display summary in command window
fprintf('\n========== FEATURE CORRELATION ANALYSIS ==========\n');
fprintf('Total Features Analyzed: %d\n', n_features);
fprintf('Top 5 Most Correlated Features:\n');
for i = 1:min(5, length(top10_idx))
    fprintf('  %d. Feature %d: %s (Correlation: %.4f)\n', ...
        i, top10_idx(i), feature_names{top10_idx(i)}, top10_corr(i));
end
fprintf('\nAnalysis completed successfully!\n');
fprintf('Results saved to:\n');
fprintf('  1. Feature_Correlation_Analysis.png\n');
fprintf('  2. Top15_Correlated_Features.xlsx\n');

%% Export Selected Feature Data
% Note: Preserving the original feature selection [1,11,12,15,19,22,25,27,28,30]
selected_features = [1, 11, 12, 15, 19, 22, 25, 27, 28, 30];
xlswrite('Extracted_Important_Features.xlsx', x(:, selected_features));

fprintf('  3. Extracted_Important_Features.xlsx\n');
fprintf('==================================================\n\n');