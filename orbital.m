function [out] = orbital(burndv, lambda, plots)
% This function calculates an orbital trajectory for a spacecraft starting from Earth in a dual-impulsive transfer
% Returned variables are VC (circularisation burn delta vee), days (transit time), thetaout (angular progression from launch in degrees)
% BurnDV is the delta-vee of the initial burn
% Lambda is the angle of the initial burn, measured in degrees clockwise from the orbital direction (positive outwards)
% by Nick Bradbeer 2005

sunmass = 2e30; %mass in kg
earthradius = 150e9; %radius in m
saturnradius = 1.4e12; %radius in m
G = 6.67e-11; %Gravitational constant in N.m2/kg2
t(1) = 0;
x(1) = earthradius;
y(1) = 0;
timestep = 24*60*60; %Seconds in a day
vsaturn = sqrt(G * sunmass ./ saturnradius);
vc = 0;
days = 0;
thetaout=0;
lambda = lambda * pi/180;

% Initial value of theta = 0 (so burn at lambda of 0 adds to vy)
% Initial velocities
vx(1) = 0 + (burndv * sin(lambda));
vy(1) = sqrt(G .* sunmass ./ earthradius) + (burndv * cos(lambda));

%Time loop
for n = 2:10000
%Adjust position by former velocity
x(n) = x(n-1)+(vx(n-1)*timestep);
y(n) = y(n-1)+(vy(n-1)*timestep);

%Find new polar position
R(n) = sqrt((x(n)^2)+(y(n)^2));
theta(n) = atan2(y(n), x(n));

%Adjust velocity by gravity
radialaccel = G * sunmass./(R(n)^2);
radialdeltavee = radialaccel *timestep;
vx(n)=vx(n-1) - (radialdeltavee * cos(theta(n)));
vy(n)=vy(n-1) - (radialdeltavee * sin(theta(n)));

%Check for destination
if R(n) > saturnradius
	%Record magnitude of circularization burn
	vcx = vx(n)-(vsaturn * cos(theta(n)+(pi/2)));
	vcy = vy(n)-(vsaturn * sin(theta(n)+(pi/2)));
	vc = sqrt((vcx^2)+(vcy^2));
	%Record traveltime
	traveltime = n * timestep;
	days = traveltime / (24*60*60);
	thetaout = theta(n)*180/pi;
	%Break
	break
	end
	
end

out = [vc days thetaout];

if plots == 1
	hold off;
	plot(y,x);
	hold on;
	axis square;
	b = 0:0.01:2*pi;
	earthx = earthradius * cos(b);
	earthy = earthradius * sin(b);
	saturnx = saturnradius * cos(b);
	saturny = saturnradius * sin(b);
	plot(earthy, earthx, '--g');
	plot(saturny, saturnx, '--r');
	end
	
end	