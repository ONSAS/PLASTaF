% ----------------------------------------------------------------------
% Example of uniaxial plasticity
% Bar with imposed strain increment
% Return method algorithm with KKT conditions
% ----------------------------------------------------------------------

clear all, close all, clc

% Definitions

% Material parameters
% ------------------------------
E = 210e9 ;
sigmaY = 250e6 ;
K = 21e9 ;

% Material variables
% ------------------------------
eps0 = 0 ;

epsMax = sigmaY / E * 1.5 ;
deltaEps = epsMax / 20 ;

loadEps = (eps0:deltaEps:epsMax)' ;
unloadEps = (epsMax:-deltaEps:-epsMax)' ;
load2Eps = (-epsMax:deltaEps:epsMax)' ;

vecEps = [ loadEps ; unloadEps ; load2Eps ; unloadEps ] ;
vecEps = [ loadEps ; unloadEps ; loadEps ] ;
nTimes = length(vecEps) ;

epsPlHist 	= zeros(nTimes,1) ;
epsElHist 	= zeros(nTimes,1) ;
epsPlaHist 	= zeros(nTimes,1) ;
sigmaHist 	= zeros(nTimes,1) ;

for i = 2:nTimes

%~ deps = vecEps(i) - vecEps(i-1) ;
%~ sigmaE = sigmaHist(i-1) + E*deps ;

sigmaE = E * (vecEps(i) - epsPlHist(i-1)) ;

phi = abs(sigmaE) - ( sigmaY + K * epsPlaHist(i-1) ) ;

	if phi <= 0 	
		sigmaHist(i) 	= sigmaE ;
		epsPlHist(i) 	= epsPlHist(i-1) ;
		epsPlaHist(i) = epsPlaHist(i-1) ;
	else
		deltaGamma = ( abs(sigmaE) - sigmaY - K * epsPlaHist(i-1) ) / (K + E) 
		sigmaHist(i) = sigmaE - E * deltaGamma * sign(sigmaE) ;
		epsPlHist(i) = epsPlHist(i-1) + deltaGamma * sign(sigmaE) ;
		epsPlaHist(i) = epsPlaHist(i-1) + deltaGamma ;
		
	end
end

figure, grid on 

lw = 3 ; ms = 5 ; plotFontSize = 20 ;
 
plot(vecEps, sigmaHist, 'b-x', 'linewidth', lw, 'markersize', ms) 
labx = xlabel('Deformacion'); laby = ylabel('Tension') ;
set(labx, 'fontsize', plotFontSize);
set(laby, 'fontsize', plotFontSize);

print('sigma_eps', '-dpng')









