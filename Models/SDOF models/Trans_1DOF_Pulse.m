%% Plots the transient response of a forced mass spring damper system 
clear all
%% simulation parameters
fs=1000;        % [Hz] sampling frequency
dt=1/fs;        % [s] delta t
t=0:dt:10;      % [s] time scale

%% Initial conditions: x(0) = 0, x'(0)=0 
initial_x    = 0.01;
initial_dxdt = 1;

%% Solve the model
options=odeset('InitialStep',dt,'MaxStep',dt);
[t,x]=ode45( @rhs, t, [initial_x initial_dxdt],options );
%% Import comparison 
% M='U:\_PhD\Datathief\ForcedResponse-InmanEngVib\figure4.csv';
% data=csvread(M,1,0);

%% Plot the results
% Plot the time series
figure
plot1=plot(t,x(:,1)); %,data(:,1),data(:,2),'g');
set(plot1,'LineWidth',2)
xlabel('t'); ylabel('x');
title('Time Series')
grid on
legend 'ODE45' 'DataThief' 
set(gca,'fontsize',20) 

%%% Calculate the PSD of the time series
FFTsize=1024;
[PSD_theory_f10Hz,F_theory_f10Hz]=pwelch(x(:,1),hanning(FFTsize),[],FFTsize,fs);
figure
p3=plot(F_theory_f10Hz,10*log10(abs(PSD_theory_f10Hz)));
xlabel('Frequency (Hz)');
ylabel('Displacement (dB re 1m)');
title('PSD of Displacement of Mass');


%% Mass-Spring-Damper system
% The equations for the mass spring damper system have to be defined
% separately so that the ODE45 solver can call it.
    function dxdt=rhs(t,x)
        mass1=100;		% [kg]
        stiff1=2000;    % [N/m]
        stiff2=0;
        damp=20;% [Ns/m] keep as a small number to fix solver errors
        f=1500*(stepfun(t,1.5)-stepfun(t,5)); %*sin(2*pi*10*t);            % [N] amplitude of driving force
                       
        dxdt_1 = x(2);
        dxdt_2 = -(damp/mass1)*x(2) - (stiff1/mass1)*x(1) -(stiff2/mass1).*x(1)^3+ (f/mass1);
        dxdt=[dxdt_1; dxdt_2];
    end