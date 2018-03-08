
function [avar]=plotADEV(data,avar,name, store)
    %close all;
    disp('now plotting')
    AV=mean(data.freq);
    AV=1
    disp('right plotADEV')
    % plot the power 
    figure1=figure(1);
    axes1 = axes('Parent',figure1,'FontWeight','bold','FontSize',14);
    plotlinewidth=4;
    box(axes1,'on');
    hold(axes1,'on');
    plot(data.time/3600, data.freq) % n do any further normalization here
    title(['Power over time: ' name],'FontSize',16,'FontName','Arial','FontWeight', 'bold');
    xlabel('time [h]','FontSize',14,'FontName','Arial','FontWeight', 'bold');
    ylabel('Power [a.u.]','FontSize',14,'FontName','Arial','FontWeight', 'bold');
 
    if store==true
    savefig('norm_Power.fig');
    saveas(figure(1),'norm_Power.bmp');   
    end
      hold off;
    
    
    
    % plot the ADEV (Y-scale log)
    figure2=figure(2);
   
    hold on;
    
    axes2 = axes('Parent',figure2,'FontWeight','bold','FontSize',14);
    %plotlinewidth=4;
    box(axes2,'on');
    hold(axes2,'on');
    %plotlinewidth=4;
    % plot with loaglog scale
    %loglog(avar.tau1/3600, avar.sig2, '.-b', 'LineWidth', plotlinewidth, 'MarkerSize', 24);
    %semilogx(tau/3600, avar.sig2, '.-b', 'LineWidth', plotlinewidth, 'MarkerSize', 24);
    errorbar(avar.tau1/3600, avar.sig2/AV, avar.sig2err/AV,'.-b', 'Markersize', 18); set(gca,'XScale','log');set(gca,'YScale','log') 
    grid on;
    title(['ADEV: ' name],'FontSize',16,'FontName','Arial');
    %set(get(gca,'Title'),'Interpreter','none');
    xlabel('\tau (hours)','FontSize',14,'FontName','Arial');
    ylabel('normalized ADEV \sigma_y ','FontSize',14,'FontName','Arial');
    %set(gca,'FontSize',14,'FontName','Arial');
    ax=gca;
    %expand the x axis a little bit so that the errors bars look nice
    adax = axis;
    axis([adax(1)*0.9 adax(2)*1.1 adax(3) adax(4)]);
    ax.XTick = [10^-3,10^-2,10^-1,10^0,10^1,10^2,10^3];
    ax.YTick = [10^-6,10^-5,10^-4,10^-3];
    if store==true
        savefig('logADEV.fig');
        saveas(figure(2),'logADEV.bmp'); 
    end
    hold off;
    
    
    % plot the ADEV (Y-scale lin)
    figure3=figure(3);
    
    axes3 = axes('Parent',figure3,'FontWeight','bold','FontSize',14);
    %plotlinewidth=4;
    box(axes3,'on');
    hold(axes3,'on');
    % plot with loaglog scale
    %loglog(avar.tau1/3600, avar.sig2, '.-b', 'LineWidth', plotlinewidth, 'MarkerSize', 24);
    %semilogx(tau/3600, avar.sig2, '.-b', 'LineWidth', plotlinewidth, 'MarkerSize', 24);
    errorbar(avar.tau1/3600, avar.sig2/AV,avar.sig2err/AV,'.-b', 'Markersize', 18); set(gca,'XScale','log');%set(gca,'YScale','log') 
    grid on;
    title(['ADEV: ' name],'FontSize',16,'FontName','Arial');
    %set(get(gca,'Title'),'Interpreter','none');
    xlabel('\tau (hours)','FontSize',16,'FontName','Arial');
    ylabel('normalized ADEV \sigma_y ','FontSize',16,'FontName','Arial');
    %set(gca,'FontSize',14,'FontName','Arial');
    ax=gca;
    %expand the x axis a little bit so that the errors bars look nice
    adax = axis;
    axis([adax(1)*0.9 adax(2)*1.1 adax(3) adax(4)]);
    ax.XTick = [10^-3,10^-2,10^-1,10^0,10^1,10^2,10^3];
    
    if store==true
        savefig('linADEV.fig');
        saveas(figure(3),'linADEV.bmp');
    end
    hold off;
       
    
    
end