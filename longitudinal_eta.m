%% Load data
session_tot = readtable("session_tot.xlsx");

%% Filter out extreme comparisons (rho <= max(qY/qX))
session_AB = session_tot(session_tot.AB_rho <= session_tot.AB_ratio_max, :);
session_BC = session_tot(session_tot.BC_rho <= session_tot.BC_ratio_max, :);
session_AC = session_tot(session_tot.AC_rho <= session_tot.AC_ratio_max, :);

%% Keep only paired sessions (same subject/session at T1 and T2)
session_AB = filter_paired_sessions(session_AB);
session_BC = filter_paired_sessions(session_BC);
session_AC = filter_paired_sessions(session_AC);

comparisons = {'AB','BC','AC'};
tables = {session_AB, session_BC, session_AC};

%% Pool eta values across experiments and comparisons
all_eta_T1 = [];
all_eta_T2 = [];

for i = 1:numel(comparisons)
    cmp = comparisons{i};
    eta_col = cmp + "_eta";
    tbl = tables{i};

    % loop across experimental contexts
    for ex = ["tra","ftr","ttr"]
        sub = tbl(tbl.expr == ex, :);

        % find sessions present at both T1 and T2
        sess_T1 = sub.session(sub.T == 1);
        sess_T2 = sub.session(sub.T == 2);
        common_sess = intersect(sess_T1, sess_T2);

        if isempty(common_sess)
            continue
        end

        % align T1 and T2 by session
        t1 = sortrows(sub(sub.T == 1 & ismember(sub.session, common_sess), :), 'session');
        t2 = sortrows(sub(sub.T == 2 & ismember(sub.session, common_sess), :), 'session');

        % extract eta
        all_eta_T1 = [all_eta_T1; t1.(eta_col)];
        all_eta_T2 = [all_eta_T2; t2.(eta_col)];
    end
end

%% Longitudinal change in eta (T2 - T1)
eta_diff = all_eta_T2 - all_eta_T1;

%% Paired non-parametric test (Wilcoxon signed-rank)
if numel(eta_diff) > 1
    p_wilcoxon = signrank(all_eta_T2, all_eta_T1);

    fprintf('Paired Wilcoxon signed-rank test (pooled analysis):\n');
    fprintf('p = %.4f\n', p_wilcoxon);
    fprintf('Median eta difference (T2 - T1) = %.4f\n', median(eta_diff));
    fprintf('Mean eta difference (T2 - T1)   = %.4f\n', mean(eta_diff));
else
    warning('Insufficient paired data for statistical test.');
end