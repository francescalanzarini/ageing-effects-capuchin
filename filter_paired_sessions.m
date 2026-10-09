function out = filter_paired_sessions(tbl)
% Keep only sessions having T==1 AND T==2, for all mkn + expr.

[g, mkn_vals, expr_vals] = findgroups(tbl.mkn, tbl.expr);
keep_mask = false(height(tbl),1);

for i = 1:max(g)
    idx_group = (g == i);
    sub = tbl(idx_group, :);

    sess_t1 = unique(sub.session(sub.T == 1));
    sess_t2 = unique(sub.session(sub.T == 2));

    common_sess = intersect(sess_t1, sess_t2);

    if ~isempty(common_sess)
        keep_mask(idx_group) = ismember(sub.session, common_sess);
    end
end

out = tbl(keep_mask, :);
end
