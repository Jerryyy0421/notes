function HW2_demo()
% demo simulation of a 1D point mass moving along the vertical axis
% system states: X = [y;dy];
% control input: u = F;

clc; clear all; close all;
global params;

M = 1 ; g = 9.81 ;
Kp=10; Kd=0;
xd=1; dxd=0;
params.M=M;
params.g =g;
params.Kp=Kp;
params. Kd=Kd;
params. xd=xd;
params.dxd=dxd;

x0=[0;0]; % x0 is the intial state of the system
tspan=[0; 100]; % simulation time
[t,x]=ode45(@sys_dynamics,tspan,x0);


% recreate control inputs
 for i=1:length(t)
     u(:,i)=controller(t(i),x(i,:)');
 end
 
 % plot the simulation data
figure; plot(t,x); legend('x','dx'); title('system states');
%figure; plot(t,x(:,1)); title('system states x');
figure; plot(t,u); legend('u'); title('control input');
end

function dx=sys_dynamics(t,x)
global params;
u=controller(t,x);
dx = x(2);
ddx = u/params.M;
dx = [dx;ddx];
end

function u=controller(t,x)
global params
x(1)=x(1);
x(2)=x(2);
u = params.Kp*(params.xd-x(1))+params.Kd*(params.dxd-x(2)); % you can put your controller here
end

