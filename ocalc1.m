function [ ] = ocalc1()

%This function populates a table of initial burns velocities and angles, and returns travel time and total delta v
% by Nick Bradbeer 2005

burnmin = 10260;	% dV (m/s) for initial burn
burnmax = 50000;   % dV (m/s) for initial burn
burnrange = 100;

lambdamin = -90; %min burn angle off track
lambdamax = 90; %max burn angle off track
lambdarange = 10;

%burns = linspace(burnmin, burnmax, burnrange);
burns = logspace(log10(burnmin), log10(burnmax), burnrange);
lambdas = linspace(lambdamin, lambdamax, lambdarange);
vc = zeros(burnrange, lambdarange);
dv = zeros(burnrange, lambdarange);
days = zeros(burnrange, lambdarange);

for burn = 1:burnrange
	for lambda = 1:lambdarange
	[out] = orbital(burns(burn), lambdas(lambda), 0);
	vc(burn, lambda) = out(1);
	dv(burn, lambda) = out(1) + burns(burn);
	days(burn, lambda) = out(2);
	end
end

%Plot time/initial burn
figure 
hold on
cmap = hsv(lambdarange);
for n = 1:lambdarange
	plot(burns, days(:,n), 'Color', cmap(n,:), 'DisplayName', strcat('Lambda = ', num2str(lambdas(n))));
	end
title('Travel time with initial Burn dV magnitude');
xlabel('Initial Burn dV magnitude (m/s)');
ylabel('Travel time (days)');
legend('-DynamicLegend', 2, 'Location', 'NorthEast');

figure
hold on
%Plot time/total burn
for n = 1:lambdarange
	plot(dv(:,n), days(:,n), 'Color', cmap(n,:), 'DisplayName', strcat('Lambda = ', num2str(lambdas(n))));
	end
title('Travel time with total dV magnitude');
xlabel('Total dV magnitude (m/s)');
ylabel('Travel time (days)');
legend('-DynamicLegend', 2, 'Location', 'NorthEast');


	
end