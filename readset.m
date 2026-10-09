%
% reads dataset
%


monkey = parset.monkey;
task = parset.experiment;
session = [parset.date,'/',num2str(parset.session)];
foodA = parset.goods{1};
foodB = parset.goods{2};
foodC = parset.goods{3};
weights = [mean(parset.goodweight_lims{1}), mean(parset.goodweight_lims{2})];
volumes = [0 0];

datasets = parset.datasets;
data = [];
for i = 1:length(datasets)
	eval(['data = [data; parset.dataset_',num2str(datasets(i)),'];']);
end

