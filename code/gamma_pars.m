
ntrials=200;

r=5;
sc=1;
c=1;
c_50=0.3;
rmax=40;
theta=0;

start_freq=14;
stop_freq=29;

%% parametric search of parameters
% tau(1): tau_e 
% tau(2): tau_i 
% tau(3): tau_g 

% tau(1,:)=[40 120 160];
% tau(2,:)=[40 150 190];
% tau(3,:)=[40 180 220];
% tau(4,:)=[50 120 160];
% tau(5,:)=[50 150 190];
% tau(6,:)=[50 180 220];
% tau(7,:)=[60 120 160];
% tau(8,:)=[60 150 190];
% tau(9,:)=[60 180 220];

tau(1,:)=[60 150 190];

%% new parameters
tau_e=60;   %in units of tens of milliseconds
% tau_i=180;    %dx parameters
% tau_g=200;    %dx parameters
tau_i=150;
tau_g=190;

wee=1.5;
wei=3.5;
wie=3.25;
wii=2.5;
wge=0.25;
wgi=0.5;
weg=0.6;

tspan=(0:0.1:1599.9); %1.6 s

E=zeros(16000,ntrials); %pre-allocate E,I,G for times 0-15000, or 1.5 s in 0.1 ms steps
I=zeros(16000,ntrials);
G=zeros(16000,ntrials);

h=spectrum.welch('Hann',512,80);

