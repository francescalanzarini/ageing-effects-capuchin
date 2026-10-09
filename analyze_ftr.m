function [psyphycell, table01all, session_table, hf] = analyze_ftr(parset, makefig, makestats, session)

% analyzes one session of FoodTransitivity (ftr)
% outputs psyphycell (parameters per pair), session_table (numerical table for all pairs)

if nargin < 2, makefig = 0; end
if nargin < 3, makestats = 0; end

pair_names = {'AB','BC','AC'};
space = 'log';
dx = 0.005;
epsilon = 1e-4;

readset
disp(['......session: ', session])

hf = [];
if makefig 
    hf = figure; end

psyphycell = -ones(3,5); % columns: x0, w, rho, eta, Rsq

for ipair = 1:3
    expairs = [4 2 3];  % column indices for the pairs in data
    ind = find(~data(:, expairs(ipair)));
    data_temp = data(ind, setdiff(1:7, expairs(ipair)));
    data_rest = [abs(data_temp(:,1:3)), sign(data_temp(:,2)), data_temp(:,4:end)];

    [table01, nstar, Rsq] = makeanalysis_fch(data_rest);

    % separate non-forced and forced choices
    table1mod = table01(table01(:,1) & table01(:,2), :);
    forcedAtab = table01(table01(:,1) & ~table01(:,2), :);
    forcedBtab = table01(~table01(:,1) & table01(:,2), :);
    nfA = size(forcedAtab, 1);
    nfB = size(forcedBtab, 1);

    xx = table1mod(:,2)./table1mod(:,1);
    if strcmp(space,'log'), xx = log(xx); end
    yy = table1mod(:,3);

    % fit cumulative normal (sigmoid)
    g = fittype('normcdf(x,x0,w)','coeff',{'x0','w'});
    [fittedmodel, goodness] = fit(xx, yy, g, ...
                                   'startpoint', [0 1], 'lower', [-Inf 0], 'upper', [Inf Inf]);

    coefit = [fittedmodel.x0, fittedmodel.w];

    % rho = indifference point
    if strcmp(space,'log')
        rho = exp(fittedmodel.x0);
    else
        rho = fittedmodel.x0;
    end

    % eta = slope
    eta = 1 / fittedmodel.w;

    % relvalue and width
    if strcmp(space,'linear')
        relvalue = fittedmodel.x0;
        width = fittedmodel.w;
    else
        relvalue = exp(fittedmodel.x0);
        width = exp(fittedmodel.w);
    end

    psyphycell(ipair,:) = [fittedmodel.x0, fittedmodel.w, rho, eta, goodness.adjrsquare];

    % plot
    if makefig
        figure(hf);
        plot_sigmoidfit_mod(xx, yy, coefit, relvalue, width, rho, eta, ...
                            nfA, nfB, forcedAtab, forcedBtab, table1mod, ipair, pair_names);
    end
end

% transitivity check & figure title
if makefig
    report = psyphycell;
    if max(abs(report(:,1))) < log(20)
        if report(1,1) + report(2,1) < 0
            report(2,1) = -report(2,1);
            report = report([3 2 1], :);
        end
        xvar = sum([report(1,1), report(2,1), -report(3,1)]);
        sigm = sqrt(sum([report(1,2), report(2,2), report(3,2)].^2));
        [~, pval] = ztest(xvar, 0, sigm);
    else
        pval = -1;
    end
    
    if exist('hf','var') && ~isempty(hf) && isvalid(hf)
        sgtitle([monkey ', session ' char(session) ...
                 ', violates transitivity? p = ' num2str(pval)], ...
                'FontName','Times New Roman','FontSize',10);
    end
end

% create numerical table for this session
param_names = {'x0','w','rho','eta','Rsq'};
session_row = [];
colnames = {};
for ip = 1:3
    session_row = [session_row, psyphycell(ip,:)];
    for pn = 1:numel(param_names)
        colnames{end+1} = [pair_names{ip} '_' param_names{pn}];
    end
end
session_table = array2table(session_row,'VariableNames',colnames);

table01all = [];  % if needed

end


