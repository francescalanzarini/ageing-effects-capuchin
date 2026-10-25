%% session_class_figure: Figures 2A, 3A and 3C of the paper
%
% Percentage of Inconsistent and Transitive sessions at T1 and T2:
%   Fig. 2A : Experiment 1               (expr = 'tra')
%   Fig. 3A : Experiment 2, food         (expr = 'ftr')
%   Fig. 3C : Experiment 2, token        (expr = 'ttr')
% The classification of each session is in the column session_class of
% session_tot.xlsx (Inconsistent = ExtremeX0 equal to 1, see README).
%
% Input  : session_tot.xlsx (folder Data; add it to the MATLAB path)
% Output : Fig2A.pdf, Fig3A.pdf, Fig3C.pdf
%          Fig2A_source_data.csv, Fig3A_source_data.csv, Fig3C_source_data.csv

%% Load data
session_tot = readtable("session_tot.xlsx");

%% Panels and plot parameters
panels = struct( ...
    'name',  {'Fig2A', 'Fig3A', 'Fig3C'}, ...
    'expr',  {"tra", "ftr", "ttr"}, ...
    'title', {'', 'Food Condition', 'Token Condition'}, ...
    'color', {[0.03 0.70 0.60], [0.42 0.53 0.78], [0.91 0.62 0.15]});   % T2 bars (T1 bars are grey)
grey = [0.73 0.73 0.73];
bar_offsets = [-0.2 0.2];   % horizontal position of the T1 and T2 bars within each group

%% One figure per panel
for ip = 1:numel(panels)
    p = panels(ip);

    % Sessions of this experiment
    sub = session_tot(string(session_tot.expr) == p.expr, :);
    cls = string(sub.session_class);

    % Number of Inconsistent and Transitive sessions at T1 and T2
    n_inc = [sum(sub.T == 1 & cls == "Inconsistent"); sum(sub.T == 2 & cls == "Inconsistent")];
    n_tra = [sum(sub.T == 1 & cls == "Transitive");   sum(sub.T == 2 & cls == "Transitive")];
    n_tot = [sum(sub.T == 1); sum(sub.T == 2)];
    assert(isequal(n_inc + n_tra, n_tot), ...
           'Some sessions are neither Inconsistent nor Transitive (%s)', p.name);

    pct_inc = 100 * n_inc ./ n_tot;
    pct_tra = 100 * n_tra ./ n_tot;

    % Bar chart: rows = Inconsistent, Transitive; columns = T1, T2
    y = [pct_inc(1) pct_inc(2); pct_tra(1) pct_tra(2)];

    fig = figure; hold on;
    b = bar(y, 'grouped');
    b(1).FaceColor = grey;     b(1).EdgeColor = 'none';
    b(2).FaceColor = p.color;  b(2).EdgeColor = 'none';

    % Percentage above each bar
    for k = 1:2
        for g = 1:2
            text(g + bar_offsets(k), y(g,k) + 2, sprintf('%d%%', round(y(g,k))), ...
                 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
        end
    end

    xticks(1:2); xticklabels({'Inconsistent', 'Transitive'});
    yticks(0:50:100); ylim([0 110]);
    ylabel('Sessions (%)');
    set(gca, 'TickDir', 'out', 'Box', 'off');
    if ~isempty(p.title), title(p.title); end
    legend(b, {'T1', 'T2'}, 'Location', 'northeast', 'Box', 'off');

    % Source data
    source = table(repmat(p.expr, 2, 1), [1; 2], n_tot, n_inc, n_tra, ...
                   round(pct_inc, 1), round(pct_tra, 1), ...
                   'VariableNames', {'experiment_code', 'T', 'n_sessions', 'n_inconsistent', ...
                                     'n_transitive', 'pct_inconsistent', 'pct_transitive'});
    writetable(source, [p.name '_source_data.csv']);

    % Save figure
    if exist('exportgraphics', 'file')
        exportgraphics(fig, [p.name '.pdf'], 'ContentType', 'vector');
    else
        print(fig, '-dpdf', '-bestfit', [p.name '.pdf']);
    end
    fprintf('%s: T1 %d/%d inconsistent, T2 %d/%d inconsistent\n', p.name, n_inc(1), n_tot(1), n_inc(2), n_tot(2));
end
