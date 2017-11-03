function Xdot=Xd(t,y)
%Define parameters from model
% k1=1000; % Not Used
m1=1;
k2=100;
m2=500*m1;
% k3=2e4;
% D=1e10; %damping coefficient 

%define 'a' coefficient to resolve large solution issue
% a=1e-6;
%define matrices from initial conditions
x1=y(1);
x2=y(2);
y1=y(3);
y2=y(4);

%set nonlinear term, k3, to 0
k3=0;

%define A matrix for EOM
A=[x2; ...
    -((k2/m1)*(x1-y1));%-((k3/m1)*((x1-y1)^4)); ...
    y2;...
    -((k2/m2)*(y1-x1))];%-((k3/m2)*((y1-x1)^4))];

% input force vector, B
B=[0 (0.1*sin(2*pi*5*t)) 0 0];

%output result as the equation 
Xdot=A+B';


end



