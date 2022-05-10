% ----------------------------------------------------------------------
% Example of FEM
% MISES truss 
% ----------------------------------------------------------------------

clear all, close all, clc

% Definitions

% Solver path
% ------------------------------

%~ curr_path = pwd ;
%~ solver_path = '../truss/' ;

% Material parameters
% ------------------------------

sigmaY = 250 ; % Yield stress 
K = 1e-6 ; % Linear hardening 

E = 210e3 ; % Elastic modulus 
Et = E*K / ( E+K ) ; % Tangent modulus

% Geometry variables
% ------------------------------

A1 = 200 ; 	% Element 1 section 
A2 = A1 ; 	% Element 2 section 

secVec = [ A1 ; A2 ] ;

l = 1000 ; % Length
aux = sqrt(2) * l ;

Nodes =  [ 0 		0 ; ...
					 aux 	aux ; ...
					 2*aux 0 ] ;

% Geometry variables
% ------------------------------

% Conec structure 
% [ nod1 nod2 A ]
Conec = [ 1 2 1 ; ...
					2 3 2 ] ;

% External forces 
% ------------------------------

% Global coordinate system
Fx = 0 ;
Fy = -7.5e3 ;

% nodalForceMatrix structure:
% [ node Fx Fy ]
nodalForceMatrix = [ 2 Fx Fy ] ; 

% Supports 
% ------------------------------

% Global coordinate system

% suppMatrix structure:
% [node kx ky ]
suppMatrix = [ 1 inf 	inf ; ...
							 3 inf 	inf	] ;


% Numerical method parameters
% ------------------------------

tolk = 3 	; % Number of iters
tolu = 1e-4 ; % Tolerance of converged disps
tolf = 1e-6 ; % Tolerance of internal forces 
nLoadSteps = 16; % Number of load increments
 
%~ loadFactorsVec = [ones(nLoadSteps,1) ; -ones(2.5*nLoadSteps,1) ; ones(3.5*nLoadSteps,1)] ;
loadFactorsVec = [ones(nLoadSteps,1) ; -ones(nLoadSteps,1) ] ;
%~ loadFactorsVec = [ones(nLoadSteps,1) ] ;

epsPl0 	= 0 ;
epsPla0 = 0 ;
sigma0 = 0 ;

% FEM
% ------------------------------

%~ cd (solver_path)


solverFEM


%~ cd (curr_path) 

% Solution check
% ------------------------------
gdl = 2*2-1 ; 
Ffem = abs(matFintL(:,2)(gdl))
Fana = abs( Fy / (2*cos(deg2rad(45))) )

err = ( Ffem - Fana ) / Fana * 100 

% plot

controlDisps = matUk(gdl,:) ;
loadFactors = loadFactorsVec ;

lw = 2.0 ; ms = 11 ; plotFontSize = 22 ;
figure
grid on
plot( controlDisps, loadFactors, 'k-o' , 'linewidth', lw,'markersize',ms )
labx = xlabel('Displacement');   laby = ylabel('$\lambda$') ;
set(labx, 'fontsize', plotFontSize);
set(laby, 'fontsize', plotFontSize);
tit = title('disp-\lambda');
set(tit, 'fontsize', plotFontSize);


figure
grid on, hold on
plot(cell2mat(epsHistElem(1,1:nLoadSteps)), cell2mat(sigmaHistElem(1,1:nLoadSteps)), 'b-x', 'linewidth', lw, 'markersize', ms) 
plot(cell2mat(epsHistElem(1,nLoadSteps:2*nLoadSteps)), cell2mat(sigmaHistElem(1,nLoadSteps:2*nLoadSteps)), 'g-o', 'linewidth', lw, 'markersize', ms)
%~ plot(cell2mat(epsHistElem(1,3.5*nLoadSteps:7*nLoadSteps)), cell2mat(sigmaHistElem(1,3.5*nLoadSteps:7*nLoadSteps)), 'b-x', 'linewidth', lw, 'markersize', ms)


labx = xlabel('Strain'); laby = ylabel('Stress') ;
set(labx, 'fontsize', plotFontSize);
set(laby, 'fontsize', plotFontSize);
tit = title('\sigma-\epsilon');
set(tit, 'fontsize', plotFontSize);



'-----------------------'
epsPlElem = cell2mat(epsPlHistElem(1,:)) ;
epsPlaElem = cell2mat(epsPlaHistElem(1,:)) ;
epsElem = cell2mat(epsHistElem(1,:)) ;

tb = 17 ; t1 = 18 ; t2 = 19

[ phiHistElem(1,tb) phiHistElem(1,t1) phiHistElem(1,t2) ]

vecEps = [ epsElem(17) epsElem(18) epsElem(19) ]
vecEpsPl = [ epsPlElem(16) epsPlElem(17) epsPlElem(18) ]
vecEpsPla = [ epsPlaElem(16) epsPlaElem(17) epsPlaElem(18) ]

vecSigmaE = E*(vecEps - vecEpsPl)
vecPhi = abs(vecSigmaE) - ( sigmaY + K * vecEpsPla )






