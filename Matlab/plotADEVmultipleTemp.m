function [plotData]=plotADEV_multipleTemp(data,avar, name, store,color, featureScaling)
     
    AV = data.average;
    tau1h = avar.tau1/3600;
    time = data.time/3600;
    
    % plot the power 
    figure(1);
    hold on;
    plotData = [tau1h; avar.sig2; avar.sig2err];
    
    if featureScaling == true
        plot(time, (data.freq-min(data.freq))/(max(data.freq)-min(data.freq)),'b.', 'Color',color,'Markersize',6) % n do any further normalization here
        ylabel('Power (feature scaled)','FontSize',14,'FontName','Arial','FontWeight', 'bold');

    else
         plot(time, data.freq,'b.', 'Color',color,'Markersize',6) % n do any further normalization here
         ylabel('Temperature [°C]','FontSize',14,'FontName','Arial','FontWeight', 'bold');
    end
    
    box on;
 
    title([name],'FontSize',16,'FontName','Arial','FontWeight', 'bold');
    
    xlabel('time [h]','FontSize',14,'FontName','Arial','FontWeight', 'bold');
    hold off;
    movegui('northwest') 

    % plot the ADEV (Y-scale log)
    figure(2);
    hold on;
    errorbar(tau1h, avar.sig2, avar.sig2err,'.-b', 'Markersize', 22, 'Color',color); set(gca,'XScale','log');set(gca,'YScale','log') 
    grid on;
    box on;
    title([name],'FontSize',16,'FontName','Arial');
    %set(get(gca,'Title'),'Interpreter','none');
    xlabel('\tau (hours)','FontSize',14,'FontName','Arial');
    ylabel('ADEV \sigma_y [°C] ','FontSize',14,'FontName','Arial');
    %set(gca,'FontSize',14,'FontName','Arial');
    ax=gca;
    adax = axis;
    axis([adax(1)*0.9 adax(2)*1.1 adax(3) adax(4)]);
    ax.XTick = [10^-3,10^-2,10^-1,10^0,10^1,10^2,10^3];
    ax.YTick = [10^-3,10^-2,10^-1,10^-0];
    hold off;
    movegui('north') 
    
    
%     % plot the ADEV (Y-scale lin)
%     figure(3);
%     hold on;
%     errorbar(tau1h, avar.sig2/AV,avar.sig2err/AV,'.-b', 'Markersize', 22, 'Color', color); set(gca,'XScale','log');%set(gca,'YScale','log') 
%     grid on;x
%     box on;
%     title([name],'FontSize',16,'FontName','Arial');
%     xlabel('\tau (hours)','FontSize',16,'FontName','Arial');
%     ylabel('relative ADEV \sigma_y ','FontSize',16,'FontName','Arial');
%     ax=gca;
%     adax = axis;
%     axis([adax(1)*0.9 adax(2)*1.1 adax(3) adax(4)]);
%     ax.XTick = [10^-3,10^-2,10^-1,10^0,10^1,10^2,10^3];
%     hold off;
%     movegui('northeast')  
    
end