winstyle = 'docked';
% winstyle = 'normal';

set(0,'DefaultFigureWindowStyle',winstyle)
set(0,'defaultaxesfontsize',18)
set(0,'defaultaxesfontname','Times New Roman')
% set(0,'defaultfigurecolor',[1 1 1])

% clear VARIABLES;
clear
global spatialFactor;
global c_eps_0 c_mu_0 c_c c_eta_0
global simulationStopTimes;
global AsymForcing
global dels
global SurfHxLeft SurfHyLeft SurfEzLeft SurfHxRight SurfHyRight SurfEzRight



dels = 0.75;
spatialFactor = 1;

c_c = 299792458;                  % speed of light
c_eps_0 = 8.8542149e-12;          % vacuum permittivity
c_mu_0 = 1.2566370614e-6;         % vacuum permeability
c_eta_0 = sqrt(c_mu_0/c_eps_0);


tSim = 200e-15 %time of simulation
f = 2* 230e12; %some frequency
lambda = c_c/f; %wave length

xMax{1} = 20e-6; %length of the x domain
nx{1} = 200; %x step
ny{1} = 0.75*nx{1}; %y step


Reg.n = 1;

mu{1} = ones(nx{1},ny{1})*c_mu_0; %permitivity

epi{1} = ones(nx{1},ny{1})*c_eps_0; 
epi{1}(125:150,55:95)= c_eps_0*11.3;
epi{1}(75:100,85:95)= c_eps_0*11.3;
epi{1}(75:100,55:65)= c_eps_0*11.3;

sigma{1} = zeros(nx{1},ny{1}); %conductivity
sigmaH{1} = zeros(nx{1},ny{1});

dx = xMax{1}/nx{1}; %x step
dt = 0.25*dx/c_c; %time step
nSteps = round(tSim/dt*2); 
yMax = ny{1}*dx; %max y domain
nsteps_lamda = lambda/dx

movie = 1;
Plot.off = 0;
Plot.pl = 0;
Plot.ori = '13';
Plot.N = 100;
Plot.MaxEz = 1.1;
Plot.MaxH = Plot.MaxEz/c_eta_0;
Plot.pv = [0 0 90];
Plot.reglim = [0 xMax{1} 0 yMax];


bc{1}.NumS = 2;
bc{1}.s(1).xpos = nx{1}/(4) + 1;
bc{1}.s(1).type = 'ss';
bc{1}.s(1).fct = @PlaneWaveBC;
% mag = -1/c_eta_0;
mag = 1; %magnitude of input signal
phi = 0; %something to do with phase
omega = f*2*pi; %rads per second or something like that
betap = 10; %I do not know
t0 = 30e-15; %start time
st = -0.05 ;%15e-15; %step time, maybe?
s = 0; %index of refraction
y0 = 0.90e-05;%yMax/2; %Where the input signal enters at
sty = 1.5*lambda; %width of my input signal
bc{1}.s(1).paras = {mag,phi,omega,betap,t0,st,s,y0,sty,'s'}; %sets up the input signal

bc{1}.s(2).xpos = nx{1}/(4) + 1;
% bc{1}.s(2).ypos = ny{1}/(3)+1;
bc{1}.s(2).type = 'ss';
bc{1}.s(2).fct = @PlaneWaveBC;
mag2 = 1; %magnitude of input signal
phi2 = 0; %something to do with phase
omega2 = f*2*pi; %rads per second or something like that
betap2 = 10; %I do not know
t02 = 30e-15; %start time
st2 = -0.05 ;%15e-15; %step time, maybe?
s2 = 0; %index of refraction
y02 = 0.80e-05;%yMax/2; %Where the input signal enters at
sty2 = 1.5*lambda; %width of my input signal
bc{1}.s(2).paras = {mag2,phi2,omega2,betap2,t02,st2,s2,y02,sty2,'s'};

Plot.y0 = round(y0/dx);

bc{1}.xm.type = 'a'; %sets the boundry condition on the lower x side
bc{1}.xp.type = 'a'; %sets the boundry condition on the higher x side
bc{1}.ym.type = 'a';
bc{1}.yp.type = 'a';


pml.width = 20 * spatialFactor;
pml.m = 3.5;



Reg.n  = 1;
Reg.xoff{1} = 0;
Reg.yoff{1} = 0;

RunYeeReg






