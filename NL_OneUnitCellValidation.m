    clear all
%% Parameters
m1=0.1; 
m2=0.5*m1;
k1=1000;
k2=320;
k2NL=2e4;

w1=sqrt((k1)/m1)/(2*pi);
w2=sqrt((k2)/m2)/(2*pi);

% effective mass
theta=m2/m1;
% w2=sqrt(k2/m2);

%% File read from APDL simulation (numerical)

file = 'C:\ANSYS\Temp\Validation\DuffingValDec17\DuffOneUnitTrans129.csv';
M=csvread(file,1,0); %start reading from row 1, column 1

ansys_time = M((1:length(M)),1); % time
t=ansys_time;
ansys_amp_1 = M((1:length(M)),2);
ansys_amp_2 = M((1:length(M)),3);
velo1=M((1:length(M)),4);
velo2=M((1:length(M)),5);

bandpassFile='C:\ANSYS\Temp\Validation\DuffingValDec17\HigherAmp.csv';
bandpass1=csvread(bandpassFile);
bandpass=bandpass1(:,2);
% [q,t5]=max(bandpass);
% figure
% plot(t,bandpass)
dt=abs(mean(diff(t))); 

% bandpass=10*(sin(10*2*pi*t)+sin(20*2*pi*t)+sin(40*2*pi*t)+sin(70*2*pi*t));
%% FFT of input (displacement)
figure
ax1=subplot(2,1,1);
dt=abs(mean(diff(t)));  %average time step done 
Fs=1/dt;
% y = fft(ansys_amp_1);  
% flop = (0:length(y)-1)*Fs/length(y);
n=length(t); %length of signal = number of samples
m=pow2(nextpow2(n));  %transform length
dft=fft(bandpass,m); % DFT of signal
fr = (0:m-1)*(Fs/m);
fourier = abs(dft); 
f=Fs*(0:(n/2))/n;
freq=fr(1:floor(m/2));
P=fourier(1:floor(m/2));
plot(freq,P)
% plot(flop,abs(y),'LineWidth',2)
title('FFT of input signal (simple)')
grid on
xlabel('Frequency,  (Hz)')
ylabel('|P1(f)|')
set(gca,'fontsize',14)
% FFT of output (displacement)
ax2=subplot(2,1,2);
dt=mean(diff(t));  %average time step done 
Fs=1/dt;
% y = fft(ansys_amp_1);  
% flop = (0:length(y)-1)*Fs/length(y);
n=length(t); %length of signal = number of samples
m=pow2(nextpow2(n));  %transform length
dft=fft(ansys_amp_1,m); % DFT of signal
fr = (0:m-1)*(Fs/m);
fourier = abs(dft); 
f=Fs*(0:(n/2))/n;
freq=fr(1:floor(m/2));
P=fourier(1:floor(m/2));
plot(freq,P)
% plot(flop,abs(y),'LineWidth',2)
title('FFT of output amp of a free-free AMM system with 7 units')
grid on
xlabel('Normalised frequency, \Omega (Hz)')
ylabel('|P1(f)|')
linkaxes([ax1,ax2],'x')
set(gca,'fontsize',14)

%% Displacement Time responses
figure
plot(ansys_time,(ansys_amp_1),ansys_time,(ansys_amp_2),'r','LineWidth',0.005)
grid on
title('Time response magnitudes for a free-free AMM system with 7 units','FontSize',14)
xlabel('Time, s','FontSize',14)
ylabel('Magnitude, u','FontSize',14)
legend({'mass_1','mass_2'},'FontSize',14)
set(gca,'fontsize',14)

%% Phase Plots and Invariant Manifolds

figure
ax1b=subplot(2,2,1);
plot(ansys_amp_1,velo1)
grid on
title('Phase plot of mass1','FontSize',20)
xlabel('displacement of mass1','FontSize',20)
ylabel('velocity of mass1','FontSize',20)

ax2a=subplot(2,2,3);
plot(ansys_amp_2,velo2);
grid on
title('Phase plot of mass2','FontSize',20)
xlabel('displacement of mass2','FontSize',20)
ylabel('velocity of mass2','FontSize',20)
ax2c=subplot(2,2,[2,4]);
plot(ansys_amp_1,ansys_amp_2)
grid on
title('Invariant manifold','FontSize',20)
xlabel('displacement of mass1','FontSize',20)
ylabel('displacement of mass2','FontSize',20)
%% Distribution of energy ratio
KE1=(0.5*m1*ansys_amp_1.^2);
KE2=(0.5*m1*ansys_amp_2.^2);
RDR=KE2./(KE1+KE2);
RDR2=KE1./(KE1+KE2);
figure
plot(ansys_time,RDR,'r')
grid on
% axis([0 1 -Inf Inf])
title('Distribution of Energy','FontSize',14)
xlabel('Time, s','FontSize',14)
ylabel('R_{DR}','FontSize',14)
legend({'mass_{ratio}'},'FontSize',14)
set(gca,'fontsize',14)
%% Loglog plot of frequency response
figure
loglog(freq,abs(P))
y1=get(gca,'ylim');
grid on
title('Frequency response magnitudes for a 10 unit NLH spring mass-spring system','FontSize',14)
xlabel('Frequency, Hz','FontSize',14)
ylabel('magnitude','FontSize',14)
% legend({'mass_1','mass_2'},'FontSize',14)
%% TF estimate
% takes in input and output signal
% bandpass filter input signal

% [txy,frequencies]=tfestimate(bandpass(:,2),ansys_amp_1,[],[],[],500);
[txy,frequencies]=tfestimate(bandpass,ansys_amp_1,[],[],[],1/dt);

% plot
figure
% hold on
plot(frequencies/w1,20*log10(abs(txy)),'r')
% axis([0 12 -Inf Inf])
grid on
title('Transfer function of metamaterial configurations','FontSize',14)
xlabel('Normalised frequency, \omega/\omega_0','FontSize',14)
ylabel('Magnitude, dB','FontSize',14)
set(gca,'fontsize',14)
% axis([0 10 -Inf 0])
legend({'linear AMM','noise insulation panel','nonlinear AMM'},'FontSize',14)
%%
% figure
hold on
graph1=loglog(frequencies/w1,abs(txy),'b');
% axis([0 3 0 Inf])
grid on
% title('TF Estimate 5unitAMM NLH chain','FontSize',14)
xlabel('Normalised frequency, \omega/\omega_0','FontSize',14)
ylabel('Magnitude, dB','FontSize',14)
set(gca,'fontsize',20)
legend({'linear AMM numerical result','nonlinear case 1 AMM numerical result','phononic crystal numerical result','nonlinear case 2 AMM numerical result'})
set(graph1,'LineWidth',2);
%%
figure
% hold on
[pxx,f] = periodogram(ansys_amp_2,[],[],1/dt);
plot(f/w1,10*log10(pxx),'k')
grid on
title('Periodogram PSD of 10 unit cell linear system','FontSize',20)
xlabel('Frequency, \omega','FontSize',20)
ylabel('Magnitude, dB','FontSize',20)
% axis([0 20 -Inf Inf])
% dt=mean(diff(bandpass(:,1)));  %average time step done 
% Fs=1/dt;
% % y = fft(ansys_amp_1);  
% % flop = (0:length(y)-1)*Fs/length(y);
% n=length(bandpass(:,1)); %length of signal = number of samples
% m=pow2(nextpow2(n));  %transform length
% dft=fft(bandpass(:,2),m); % DFT of signal
% fr = (0:m-1)*(Fs/m);
% fourier = abs(dft); 
% f=Fs*(0:(n/2))/n;
% freq=fr(1:floor(m/2));
% P1=fourier(1:floor(m/2));
% figure
% plot(freq,P,'g',freq,P1,'b')
%% M_effective
% effective mass
Mr=m2/m1; %mass ratio
Sr=k2/k1; %stiffness ratio
Tr=Mr/Sr;
upper=sqrt(1+Mr);

lower=(1/sqrt(2))*sqrt((1+Mr+4*Tr)-sqrt((1+Mr+4*Tr)^2-16*Tr));


w=linspace(0,w1*2*pi*2.5,80000);
wT=sqrt(k2/m2);
A=w;
B=wT;
C=A./B;

meff=m1+(m2*wT^2)./(wT^2-A.^2);

% figure
% plot(meff/m1,C)
% grid
% axis([-20 20 0 3])
% Dispersion relation (theoretical prediction)
% Yao 2008 
qL=2*asin(sqrt((meff)/(4*k1).*A.^2));

% figure
% plot(A/(2*pi),real(qL)/pi)
% grid
% axis([0 12 0 1])

% Transmittance of cells
% Pls automate somehow
B=A/(2*pi);
T7=(k1)./(k1*(1)-meff.*A.^2);
T6=(k1)./(k1*(2-T7)-meff.*A.^2);
T5=(k1)./(k1*(2-T6)-meff.*A.^2);
T4=(k1)./(k1*(2-T5)-meff.*A.^2);
T3=(k1)./(k1*(2-T4)-meff.*A.^2);
T2=(k1)./(k1*(2-T3)-meff.*A.^2);
T1=(k1)./(k1*(2-T2)-meff.*A.^2);
% figure
Tall=T7+T6+T5+T4+T3+T2+T1;
% semilogy(B,abs(Tall))
% grid

%% Graph 3 plots together (dispersion relation, theoretical transmittance,
% numerical transmittance)
SP=upper*w2; %upper limit of bandgap - work out how to calculate - band gap upper and lower limit
VP=lower*w2; %lower limit
figure
%------------SubPlot1----------------%
ay1=subplot(1,3,3);
semilogx(abs(txy),frequencies)
grid
line(xlim,[SP SP],'Color',[1 0 0])
line(xlim,[VP VP],'Color',[1 0 0])
axis([0.01 40 0 VP*3.5])
xlabel('Magnitude, dB','FontSize',14)
legend({'Numerical Result (APDL)'},'FontSize',14)
set(gca,'fontsize',14)
%------------SubPlot2----------------%
ay2=subplot(1,3,2);
semilogx(abs(Tall),B)
grid
line(xlim,[SP SP],'Color',[1 0 0])
line(xlim,[VP VP],'Color',[1 0 0])
% axis([0 12 -10 100])
title('Dispersion Relation and Transmittance of free-free AMM system with 7 units (validation of Yao 2008)','FontSize',14)
xlabel('Magnitude, dB','FontSize',14)
legend({'Theoretical Result'},'FontSize',14)
set(gca,'fontsize',14)
%------------SubPlot3----------------%
ay3=subplot(1,3,1);
plot(real(qL)/pi,A/(2*pi))
% axis([0 12 0 1])
grid
line(xlim,[SP SP],'Color',[1 0 0])
line(xlim,[VP VP],'Color',[1 0 0])
ylabel('Frequency, Hz','FontSize',14)
xlabel('Real(qa/\pi)' ,'FontSize',14)
legend({'Dispersion Relation'},'FontSize',14)
set(gca,'fontsize',14)
% linkaxes([ay1,ay2,ay3],'x')  

%% External Work done by a single unit cell AMM
time=linspace(0,100,1000);
Amp=0.01;

om1=1.080*w2;
om2=om1/w2;
Kr=Sr;
%-----------------------------------------
F1=0.25*(1-cos(2*om1*time));
F2=0.5*(1/(1+om2)*(1-cos((w2+om1)*time))+(1/(1-om2))*(1-cos((w2-om1)*time)));
%-----------------------------------------
We=m1*Amp^2*w2^2*((Mr/Kr-om2^2-(Mr*om2^2)/(1-om2^2))*F1+(Mr*om2^2)/(1-om2^2)*F2);

figure
plot(time,We)