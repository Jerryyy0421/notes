
% demo simulation of a 1D point mass moving along the vertical axis
% system states: X = [y;dy];
% control input: u = F;

clc; clear all; close all;
global params;

m = 0.5 ; g = 9.81 ; u=1;
params.m=m;
params.g =g;
params.u=u;
x0=[0.1;0.2]; % x0 is the intial state of the system
tspan=[0; 1]; % simulation time
[t,x]=ode45(@sys_dynamics,tspan,x0);

 
 % plot the simulation data
figure; plot(t,x); legend('y','dy'); title('system states');


function dx=sys_dynamics(t,x)
global params;
dy = x(2);
ddy = params.u/params.m-params.g;
dx = [dy;ddy];
end









