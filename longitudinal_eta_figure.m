%% longitudinal_eta_figure: Figure 4 of the paper
%
% Scatter plot of the slope eta at T2 against eta at T1 for all paired
% comparisons (AB, BC, AC) of all experiments (tra, ftr, ttr).
% Each point is one paired comparison: the same monkey, experiment and
% session number at T1 and T2. The data selection is the same as in
% longitudinal_eta.m.
%
% Input  : session_tot.xlsx (folder Data; add it to the MATLAB path)
% Output : Fig4_eta_T1_vs_T2.pdf   (figure)
%          Fig4_source_data.csv    (data plotted in the figure)
% Requires: filter_paired_sessions.m

%% Load data
session_tot = readtable("session_tot.xlsx");

%% Select comparisons
% Exclude extreme comparisons (rho > maximum quantity ratio offered)
session_AB = session_tot(session_tot.AB_rho <= session_tot.AB_ratio_max, :);
session_BC = session_tot(session_tot.BC_rho <= session_tot.BC_ratio_max, :);
session_AC = session_tot(session_tot.AC_rho <= session_tot.AC_ratio_max, :);

% Keep only sessions present at both T1 and T2 (same monkey and experiment)
session_AB = filter_paired_sessions(session_AB);
session_BC = filter_paired_sessions(session_BC);
session_AC = filter_paired_sessions(session_AC);

comparisons = {'AB','BC','AC'};
tables      = {session_AB, session_BC, session_AC};
experiments = ["tra","ftr","ttr"];

%% Plot parameters
colors  = struct('tra',[0 0.7 0.6], 'ftr',[0.2 0.6 1], 'ttr',[1 0.7 0]);  % experiment
markers = struct('AB','o', 'BC','s', 'AC','^');                           % comparison
axis_max = 16;

fig = figure; hold on;
xlabel('\eta T1'); ylabel('\eta T2');
xlim([0 axis_max]); ylim([0 axis_max]);
xticks(2:2:20);
set(gca, 'TickDir', 'out')
axis square;
plot([0 axis_max],[0 axis_max],'k--','LineWidth',1,'HandleVisibility','off');  % identity line

%% Plot eta(T2) against eta(T1), for each comparison and experiment
handles = gobjects(0);
labels  = {};
rows    = {};   % data plotted, for the source data file

for i = 1:numel(comparisons)
    cmp     = comparisons{i};
    eta_col = cmp + "_eta";
    tbl     = tables{i};

    for ex = experiments
        sub = tbl(string(tbl.expr) == ex, :);

        % Sessions present at both T1 and T2, identified by monkey and session number
        key     = string(sub.mkn) + "_" + string(sub.session);
        common  = intersect(key(sub.T == 1), key(sub.T == 2));
        in_pair = ismember(key, common);

        % Align T1 and T2 by monkey and session number
        t1 = sortrows(sub(sub.T == 1 & in_pair, :), {'mkn','session'});
        t2 = sortrows(sub(sub.T == 2 & in_pair, :), {'mkn','session'});
        assert(isequal(string(t1.mkn), string(t2.mkn)) && isequal(t1.session, t2.session), ...
               'T1 and T2 rows are not aligned (%s, %s)', cmp, ex);

        x = t1.(eta_col);
        y = t2.(eta_col);

        % Data for the source data file
        n = height(t1);
        rows{end+1} = table(string(t1.monkey), string(t1.mkn), repmat(ex, n, 1), ...
                            t1.session, repmat(string(cmp), n, 1), x, y, y - x, ...
                            'VariableNames', {'monkey','mkn','experiment_code','session', ...
                                              'comparison','eta_T1','eta_T2','eta_diff_T2_minus_T1'}); %#ok<SAGROW>

        % A combination without data is still drawn (invisible), so that it is in the legend
        if isempty(x), x = NaN; y = NaN; end
        handles(end+1) = scatter(x, y, 80, colors.(char(ex)), markers.(cmp), 'filled'); %#ok<SAGROW>
        labels{end+1}  = sprintf('%s %s', cmp, char(ex)); %#ok<SAGROW>
    end
end

legend(handles, labels, 'Location', 'best');

%% Save figure and source data
source = vertcat(rows{:});
fprintf('Fig. 4: %d paired comparisons\n', height(source));
writetable(source, 'Fig4_source_data.csv');

if exist('exportgraphics', 'file')
    exportgraphics(fig, 'Fig4_eta_T1_vs_T2.pdf', 'ContentType', 'vector');
else
    print(fig, '-dpdf', '-bestfit', 'Fig4_eta_T1_vs_T2.pdf');
end
