%  Gamma model

clear all;

gamma_pars;
rmax=(40:-4:4);
ntrials=200;
r=5;
tau1=[60 150 190];

for i=1:5
    tau(i,:)=tau1*(1+(i-1)/10);
end

for rr=1:size(tau,1)
    for qq=1:length(rmax)
        for j=1:ntrials

            input_e=poissrnd(rmax(qq)*(c^2/(c^2+c_50^2))*sc*((1+cos(theta)^2)/2),16000,1);
            input_i=poissrnd(rmax(qq)*(c^2/(c^2+c_50^2))*sc*((1+cos(theta)^2)/2),16000,1)*0.8;

            for t=2:length(tspan)
                edot = (-E(t-1,j) + wee*max([E(t-1,j) 0])*sc - wie*max([I(t-1,j) 0]) + wge*max([G(t-1,j) 0]) + input_e(t))/tau(rr,1);
                idot = (-I(t-1,j) + wei*max([E(t-1,j) 0])*sc - wii*max([I(t-1,j) 0]) + wgi*max([G(t-1,j) 0]) + input_i(t))/tau(rr,2);
                gdot = (-G(t-1,j) + weg*max([E(t-1,j) 0])*sc*r^2)/tau(rr,3);

                E(t,j)=E(t-1,j)+edot;
                I(t,j)=I(t-1,j)+idot;
                G(t,j)=G(t-1,j)+gdot;
            end

            E2=E(1:10:end,j);
            I2=I(1:10:end,j);
            G2=G(1:10:end,j);

            E2=E2(end-1100:end);
            I2=I2(end-1100:end);
            G2=G2(end-1100:end);

            temp=psd(h,E2,'Fs',1000);
            spect_e(rr,qq,j,:)=temp.data;
            e_rate(rr,qq,j)=mean(E2);
            gamma_power_e(rr,qq,j)=sum(spect_e(rr,qq,j,start_freq:stop_freq));
            gam_ind=find(spect_e(rr,qq,j,start_freq:stop_freq)==max(spect_e(rr,qq,j,start_freq:stop_freq)));
            peak_gamma_e(rr,qq,j)=temp.freq(gam_ind+start_freq-1);

            temp=psd(h,I2,'Fs',1000);
            spect_i(rr,qq,j,:)=temp.data;
            i_rate(rr,qq,j)=mean(I2);
            gamma_power_i(rr,qq,j)=sum(spect_i(rr,qq,j,start_freq:stop_freq));
            gam_ind=find(spect_i(rr,qq,j,start_freq:stop_freq)==max(spect_i(rr,qq,j,start_freq:stop_freq)));
            peak_gamma_i(rr,qq,j)=temp.freq(gam_ind+start_freq-1);
            
            g_rate(rr,qq,j)=mean(G2);
            
        end

        disp([rr qq])

    end

end

figure
subplot(3,1,1)
aa=squeeze(mean(gamma_power_e,3));
h=plot(rmax,aa'/max(aa(:)),'ok-');
set(h,'MarkerFaceColor','w')
box off
xlabel('R_m_a_x')
ylabel('Normalized gamma power')
set(gca,'TickLength',[0.03 0],'PlotBoxAspectRatio',[3 2 1])

subplot(3,1,2)
aa=squeeze(mean(peak_gamma_e,3));
h=plot(rmax,aa,'or-');
set(h,'MarkerFaceColor','w')
box off
set(gca,'YTick',[25 35 45],'YTickLabel',[25 35 45])
xlabel('R_m_a_x')
ylabel('Peak gamma frequency (Hz)')
axis([0 40 25 45])
set(gca,'TickLength',[0.03 0],'PlotBoxAspectRatio',[3 2 1])

subplot(3,1,3)
aa=squeeze(mean(e_rate,3));
h=plot(rmax,aa/max(aa(:)),'ok-');
set(h,'MarkerFaceColor','w')
box off
set(gca,'YTick',[30 35 40 45],'YTickLabel',[30 35 40 45])
xlabel('R_m_a_x')
ylabel('Peak gamma frequency (Hz)')
set(gca,'TickLength',[0.03 0],'PlotBoxAspectRatio',[3 2 1])



