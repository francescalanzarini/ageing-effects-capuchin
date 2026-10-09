function [table01,nstar,Rsq]=makeanalysis_fch(data)

%
% makes the actual analysis  of the data of experiments.
%
%

%make table of results
[offer,j,groups]=unique(data(:,2:3),'rows');
choiz=data(:,4).*data(:,5);
for i=1:size(offer,1)
	ind=find(groups==i);
	perc_A(i,1)=length(find(choiz(ind)==+1))/length(ind);	%perc of ch A
	perc_B(i,1)=length(find(choiz(ind)==-1))/length(ind);	%perc of ch nB
	%
	lats=data(ind,6); 
	if isempty(find(lats>0)) & size(data,2)>=8
		lats=data(ind,8); 
	end
	iind=find(lats>0);
	if ~isempty(iind)
		latency_mean(i,1)=mean(lats(iind)); latency_std(i,1)=std(lats(iind));
	else
		latency_mean(i,1)=0; latency_std(i,1)=0;
	end

	try,	secondthought(i,1)=length(find(data(ind,7)>0));
	catch,	secondthought(i,1)=0; end
	Ntrials(i,1)=length(ind);
end
table=[];
table=[offer,perc_B,latency_mean,latency_std,secondthought,Ntrials];

%sort choices
[ratios,jnd]=sort(table(:,2)./table(:,1));
table01=table(jnd,:);

%fit step function and find R^2 and nstar
xx=table01(:,2)./table01(:,1);
yy=table01(:,3);
%
bb=[xx;(xx(1:end-1)+xx(2:end))/2; 0; Inf];
bb=sort(bb);
%
for i=1:length(bb)
	n=bb(i);
	err_n(i,1)=sum((yy-(sign(xx-n)+1)/2).^2);
end
Rsq=min(err_n);
nstar=bb(find(err_n-Rsq<10^(-6)));
nstar=[min(nstar),max(nstar)];
