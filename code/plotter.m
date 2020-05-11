clear all

fil{1}='size_sims2';
fil{2}='sc_sims2';
fil{3}='con_sims2';
fil{4}='ori_sims2';

% *_sims:   variations of tau_e, tau_i, tau_g; generally produce similar effects
% *_sims2:  the standard
% *_sims3:  rectify e so it is 'spike rate'

akcolor=summer;
akcolor2=flipud(akcolor);

for yy=1:9

%     figure

    for i=1:length(fil)

        load(fil{i})

        freq=temp.Frequencies;

        if i==1;
            var=r;
        elseif i==2
            var=1-sc;
        elseif i==3
            var=c;
        elseif i==4
            var=theta;
        end

        subplot(4,4,(i-1)*4+1)
        steps=floor(64/size(spect_e,2));
        for j=1:size(spect_e,1)
            aa=squeeze(mean(spect_e(yy,:,:,:),3));
            if i==1 || i==3
                for k=1:size(aa,1)
                    plot(freq,aa(k,:),'Color',akcolor2((k-1)*steps+1,:))
                    hold on
                end
            elseif i==2
                for k=1:size(aa,1)
                    plot(freq,aa(k,:),'Color',akcolor((k-1)*steps+1,:))
                    hold on
                end
            else
                steps=16;
                for k=1:4
                    plot(freq,aa(k,:),'Color',akcolor((k-1)*steps+1,:))
                    hold on
                end
            end
        end
        axis([20 100 0 0.125])
        set(gca,'XTick',[20 40 60 80 100],'XTickLabel',[20 40 60 80 100])
        xlabel('Frequency (Hz)');ylabel('Power')
        legend;

        subplot(4,4,(i-1)*4+2)
        h=plot(var,squeeze(mean(peak_gamma_e(yy,:,:),3)),'or-');
        set(h,'MarkerFaceColor','w')
        if i==1
            xlabel('Stimus size');ylabel('Peak Frequency')
        elseif i==2
            set(gca,'XLim',[0 0.6],'XTick',[0 0.2 0.4 0.6])
            xlabel('Masking noise');ylabel('Peak Frequency')
        elseif i==3
            set(gca,'XScale','log','XLim',[0.01 1],'XTick',[0.01 0.1 1],'XTickLabel',[0.01 0.1 1])
            xlabel('Contrast');ylabel('Peak Frequency')
        else
            set(gca,'XTick',[-90 -45 0 45 90])
            xlabel('Orientation');ylabel('Peak Frequency')
        end
        set(gca,'YLim',[25 55],'YTick',[25 35 45 55])

        subplot(4,4,(i-1)*4+3)
        gp=squeeze(mean(gamma_power_e(yy,:,:),3));
        h=plot(var,gp/max(gp),'ok-');
        set(h,'MarkerFaceColor','w')
        if i==1
            xlabel('Stimus size');ylabel('Normalized gamma power')
        elseif i==2
            set(gca,'XLim',[0 0.6],'XTick',[0 0.2 0.4 0.6])
            xlabel('Masking noise');ylabel('Normalized gamma power')
        elseif i==3
            set(gca,'XScale','log','XLim',[0.01 1],'XTick',[0.01 0.1 1],'XTickLabel',[0.01 0.1 1])
            xlabel('Contrast');ylabel('Normalized gamma power')
        else
            set(gca,'XTick',[-90 -45 0 45 90])
            xlabel('Orientation');ylabel('Normalized gamma power')
        end
        set(gca,'YLim',[0 1],'YTick',[0 0.5 1])
        
        subplot(4,4,(i-1)*4+4)
        rate=squeeze(mean(e_rate(yy,:,:),3));
        disp(max([zeros(1,length(rate));rate/max(rate)]))
        h=plot(var,max([zeros(1,length(rate));rate/max(rate)]),'ok-');
        set(h,'MarkerFaceColor','w')
        if i==1
            xlabel('Stimus size');ylabel('Normalized rate')
        elseif i==2
            set(gca,'XLim',[0 0.6],'XTick',[0 0.2 0.4 0.6])
            xlabel('Masking noise');ylabel('Normalized rate')
        elseif i==3
            set(gca,'XScale','log','XLim',[0.01 1],'XTick',[0.01 0.1 1],'XTickLabel',[0.01 0.1 1])
            xlabel('Contrast');ylabel('Normalized rate')
        else
            set(gca,'XTick',[-90 -45 0 45 90])
            xlabel('Orientation');ylabel('Normalized rate')
        end
        set(gca,'YLim',[0 1],'YTick',[0 0.5 1])

    end

    for i=1:16
        subplot(4,4,i)
        box off
        set(gca,'PlotBoxAspectRatio',[3 2 1],'TickLength',[0.04 0])
    end
end
