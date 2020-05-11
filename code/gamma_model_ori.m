%  Gamma model

clear all

gamma_pars;
theta=-90:30:90;

for rr=1:size(tau,1)
    for qq=1:length(theta)
        for j=1:ntrials

            input_e=poissrnd(rmax*(c^2/(c^2+c_50^2))*sc*((1+cos((theta(qq)/360)*2*pi)^2)/2),16000,1);
            input_i=poissrnd(rmax*(c^2/(c^2+c_50^2))*sc*((1+cos((theta(qq)/360)*2*pi)^2)/2),16000,1)*0.8;

            for t=2:length(tspan),
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

            E2=E2(end-1300:end);
            I2=I2(end-1300:end);
            G2=G2(end-1300:end);

            temp=psd(h,E2,'Fs',1000);
            spect_e(rr,qq,j,:)=temp.data;
            E2(find(E2<0))=0;
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
        end

        disp([rr qq])


    end

end