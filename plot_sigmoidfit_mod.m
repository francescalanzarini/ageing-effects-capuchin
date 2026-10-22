% new version September 2025

function plot_sigmoidfit_mod(xx, yy, coefit, relvalue, width, rho, eta, ...
                             nfA, nfB, forcedAtab, forcedBtab, table1mod, ipair, pair_names)

% --- Create figure if it does not exist ---
if ipair == 1  % only once for the first pair
    if isempty(findobj('Type','figure'))
        figure;
    end
end

% Force pairs to be AB, BC, AC
pair_order = {'AB','BC','AC'};
pair_name = pair_order{ipair};

% Create subplot 1x3
subplot(1,3,ipair); hold on; box on; set(gca,'fontsize',8)
a = get(gca,'position'); a(4) = 0.7; set(gca,'position',a);

% Check if there is data to plot
if isempty(xx) || isempty(yy)
    title([pair_name ' (no data)'])
    set(gca,'ylim',[0 1],'ytick',0:0.25:1)
    return
end

% --- Plot fitted sigmoid ---
x = min(xx)-log(2)/2 : 0.05 : max(xx)+log(2)/2;  % domain
y_choicefit = normcdf(x,coefit(1),coefit(2));
plot(x,y_choicefit,'b-','LineWidth',2);

% --- Plot choice pattern ---
plot(xx,yy,'ko','MarkerSize',8,'MarkerFaceColor',[0 0 0]);

% --- Add forced choices ---
xx_forcedA = sort(min(xx)-log(2)*(1:nfA))';
xx_forcedB = sort(max(xx)+log(2)*(1:nfB))';
plot(xx_forcedA, zeros(1,nfA),'ko','MarkerSize',8,'MarkerFaceColor',[0 0 0])
plot(xx_forcedB, ones(1,nfB),'ko','MarkerSize',8,'MarkerFaceColor',[0 0 0])

% --- X labels ---
[junk, ind, jjunk] = unique(xx);
xxx = xx(ind);
xlab = cell(1,nfA + length(xxx) + nfB);
for ifA = 1:nfA
    xlab{ifA} = [num2str(forcedAtab(nfA-ifA+1,2)),':',num2str(forcedAtab(nfA-ifA+1,1))];
end
for i = 1:length(xxx)
    xlab{nfA+i} = [num2str(table1mod(ind(i),2)),':',num2str(table1mod(ind(i),1))];
end
for ifB = 1:nfB
    xlab{nfA+length(xxx)+ifB} = [num2str(forcedBtab(nfB-ifB+1,2)),':',num2str(forcedBtab(nfB-ifB+1,1))];
end

xxx = [xx_forcedA; xxx; xx_forcedB];
set(gca,'xtick',xxx,'xticklabel',xlab)

% --- Axis limits ---
set(gca,'ylim',[0 1],'ytick',0:0.25:1)
set(gca,'xlim',[min(x)-0.5*log(2), max(x)+0.5*log(2)])

% --- Labels ---
xlabel(['Offers ( #' pair_name(2) ' : #' pair_name(1) ')' ], 'fontsize',8)
ylabel(['% of ' pair_name(2) ' choices'], 'fontsize',8)

% --- Annotate mu, sigma, rho, eta ---
yl = ylim; xl = xlim;
text(xl(1)+0.05*range(xl), yl(2)-0.05*range(yl), ['\mu = ' num2str(relvalue,3)], 'FontSize',8)
text(xl(1)+0.05*range(xl), yl(2)-0.12*range(yl), ['\sigma = ' num2str(width,3)], 'FontSize',8)
text(xl(1)+0.05*range(xl), yl(2)-0.19*range(yl), ['\rho = ' num2str(rho,3)], 'FontSize',8)
text(xl(1)+0.05*range(xl), yl(2)-0.26*range(yl), ['\eta = ' num2str(eta,3)], 'FontSize',8)

% --- Resize figure for the third subplot ---
if ipair==3
    set(gcf,'Position',[200 540 1200 410])
end

end





% % function plot_sigmoidfit_mod(xx, yy, coefit, relvalue, width, rho, eta, ...
% %                              nfA, nfB, forcedAtab, forcedBtab, table1mod, ipair, pair_names)
% % 
% % pair_name = pair_names{ipair};
% % 
% % subplot(1,3,ipair); hold on; box on; set(gca,'fontsize',8)
% % a = get(gca,'position'); a(4) = .7; set(gca,'position',a);
% % 
% % %
% % %plot fitted sigmoid
% % x = [min(xx)-log(2)/2 : .05 : max(xx)+log(2)/2];	%domain for plot
% % y_choicefit = normcdf(x,coefit(1),coefit(2));
% % plot(x,y_choicefit,'b-','linewidth',4);
% % 
% % %
% % %plot choice pattern
% % plot(xx,yy,'ko','markersize',12,'markerfacecolor',[0 0 0])
% % %
% % %add forced choices
% % xx_forcedA = min(xx)-log(2)*[1:nfA];	xx_forcedA = sort(xx_forcedA)';
% % xx_forcedB = max(xx)+log(2)*[1:nfB];	xx_forcedB = sort(xx_forcedB)';
% % plot(xx_forcedA,zeros(1,nfA),'ko','markersize',12,'markerfacecolor',[0 0 0])
% % plot(xx_forcedB, ones(1,nfB),'ko','markersize',12,'markerfacecolor',[0 0 0])
% % 
% % %
% % %cosmetics
% % set(gca,'xlim',[min(xx)-.5*log(2) max(xx)+.5*log(2)])
% % %
% % [junk,ind,jjunk] = unique(xx);	%remove doubles in xx
% % xxx = xx(ind);
% % %
% % %xlabels
% % xlab = [];
% % for ifA = 1:nfA
% % 	xlab{ifA} = [num2str(forcedAtab(nfA-ifA+1,2)),':',num2str(forcedAtab(nfA-ifA+1,1))];
% % end
% % for i = 1:size(xxx,1)
% % 	xlab{nfA+i} = [num2str(table1mod(ind(i),2)),':',num2str(table1mod(ind(i),1))]; 
% % end
% % for ifB = 1:nfB
% % 	xlab{nfA+i+ifB} = [num2str(forcedBtab(nfB-ifB+1,2)),':',num2str(forcedBtab(nfB-ifB+1,1))];
% % end
% % %
% % %add forced choices
% % xxx = [xx_forcedA;xxx;xx_forcedB];
% % set(gca,'xtick',xxx,'xticklabel',xlab)
% % set(gca,'ylim',[0,1]); 
% % set(gca,'ytick',[0:.25:1],'yticklabel',[0:25:100])
% % 
% % % % % to have mu and sigma written on the plot
% % % % text(min(x)+.25,.925,['\mu = ',		sprintf('%1.3g',relvalue)],'fontsize',9)
% % % % text(min(x)+.25,.855,['\sigma = ',	sprintf('%1.3g',width)],	'fontsize',9)
% % 
% % %
% % if		(ipair<3)	goods = {pair_name(1), pair_name(2)};
% % elseif	(ipair==3)	goods = {pair_name(2), pair_name(1)};
% % end
% % string_x = ['Offers ( #',goods{2},' : #',goods{1},' )'];	xlabel(string_x,'fontsize',8);
% % string_y = ['% of ',goods{2},' choices'];					ylabel(string_y,'fontsize',8);
% % %
% % if (ipair==3) set(gcf,'position',[200 540 1200 410]); end
% % 
% % % FL addition about rho and eta
% % hold on
% % yl = ylim;
% % xl = xlim;
% % 
% % text(xl(1) + 0.05*range(xl), yl(2) - 0.1*range(yl), ...
% %     ['\rho = ', num2str(rho,3)], ...
% %     'FontName','Times New Roman','FontSize',8);
% % 
% % text(xl(1) + 0.05*range(xl), yl(2) - 0.2*range(yl), ...
% %     ['\eta = ', num2str(eta,3)], ...
% %     'FontName','Times New Roman','FontSize',8);
