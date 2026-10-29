
figure;
starttime=Ts_tot(1);
endtime=Ts_tot(1)+(25000*60*5);
index=find(Ts_tot>starttime & Ts_tot<endtime);
plot(Ts_tot(index),Cs_tot(index),"|");