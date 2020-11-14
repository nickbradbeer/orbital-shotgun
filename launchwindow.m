function[] = launchwindow()
%This function computes the maximum and minimum angular progression
%by Nick Bradbeer 2005

synodic = 380;  %Synodic period in days

burnmin = 10000;	% dV (m/s) for initial burn
burnmax = 15000;   % dV (m/s) for initial burn
burnrange = 30;

lambdamin = -30; %min burn angle off track
lambdamax = 30; %max burn angle off track
lambdarange = 300;

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
	theta(burn, lambda) = out(3);
	if theta(burn, lambda) < 0 
		theta(burn, lambda) = theta(burn, lambda)+360;
		end
	end
end

%Calculate initial position of Saturn for each case
SatInitial = (theta .* synodic ./360) - days;


%Plot total dV / initial position
figure
hold on
cmap = hsv(lambdarange);
for n = 1:lambdarange
	plot(dv(:,n), SatInitial(:,n), 'o', 'Color', cmap(n,:), 'DisplayName', strcat('Lambda = ', num2str(lambdas(n))));
	end
title('Launch Window with deltaV');
xlabel('deltaV (m/s)');
ylabel('Launch Day (days)');
%legend('-DynamicLegend', 2, 'Location', 'NorthEast');