% ----------------------------------------------------------------------
% Example of cantilever beam
% ----------------------------------------------------------------------

clear all, close all, clc

% Definitions

% Problem name
% ------------------------------
problemName = 'Example5_beam_' ;


% Solver path
% ------------------------------

curr_path = pwd ;
solver_path = '../../src/beams/' ;

% Material parameters
% ------------------------------

sigmaY = 250e3 ; 	% Yield stress 
K = 0 ; 					% Linear hardening 
E = 210e6 ; 			% Elastic modulus

% Geometry variables
% ------------------------------

b = 0.1 ; % section width
h = 0.1 ;	% section height

secVec = [ b h ] ;

L = 1 ; % Length
nnodesMesh = 20 ;
xcoords = linspace(0,L,nnodesMesh)' ;
ycoords = zeros(length(xcoords),1) ;
 
Nodes = [ xcoords ycoords ] ;
%~ Nodes =  [ 0 0 ; ...
					 %~ l 0 ] ;

% Geometry variables
% ------------------------------

% Conec structure 
% [ nod1 nod2 sec ]
vec1 = (1:1:(length(xcoords)-1))' ;
vec2 = (2:1:(length(xcoords)))' ;
vec3 = ones(length(vec1),1) ;
Conec = [ vec1 vec2 vec3 ] ;

% External forces 
% ------------------------------

% Global coordinate system

Fy = -1 ;
Mz = 0 ;

% nodalForceMatrix structure:
% [ node Fy Mz ]
nod = size(Nodes,1) ;
nodalForceMatrix = [ nod Fy Mz ] ; 

% Supports 
% ------------------------------

% Global coordinate system

% suppMatrix structure:
% [node kx ky ]
suppMatrix = [ 1 	inf inf ] ;


% Numerical method parameters
% ------------------------------

tolk = 50 	; % Number of iters
tolu = 1e-4 ; % Tolerance of converged disps
tolf = 1e-6 ; % Tolerance of internal forces
nLoadSteps = 60 ; % Number of load increments
 
fac = 1; 
unloadSize = 3 ;
loadFactorsVec = [ ones(nLoadSteps,1) ] ; 
loadFactorsVec = [ ones(nLoadSteps,1) ; -fac*ones(unloadSize,1) ] ; 
 
% Plot parameters
% ------------------------------
% Figure names
nameUndeformed = [ problemName 'Undeformed' ] ;
nameMk = [ problemName 'M-k' ] ;
nameDeformed = [ problemName 'Deformed' ] ;

% Deformed structure
plotsVec = [ 59 ] ;



% FEM
% ------------------------------

cd (solver_path)

solverFEM

cd (curr_path) 



% Plots
% ------------------------------

My = sigmaY * b*h^2/6 
Mp = sigmaY * b*h^2/4 
kappa_e = 2*sigmaY/(E*h) 

elem 				= 1 ;
plotLoadVec = [1:(nLoadSteps)] ;
scaleFactor = 1 ;

figure
hold on, grid on

lw = 2.0 ; ms = 11 ; plotFontSize = 22 ;
%~ plot(abs(cell2mat(kappaHistElem(elem,plotLoadVec)))/kappa_e, abs(matFintL(2,(1:(nLoadSteps))))/My, 'b-o', 'linewidth', lw, 'markersize', ms)
%~ plot(abs(cell2mat(kappaHistElem(elem,plotLoadVec)))/kappa_e, abs(matFintL(2,(1:(nLoadSteps))))/My, 'b-o', 'linewidth', lw, 'markersize', ms)


plot(abs(cell2mat(kappaHistElem(elem,1:nLoadSteps))), abs(matFintL(2,(1:nLoadSteps))), 'b-o', 'linewidth', lw, 'markersize', ms)
plot(abs(cell2mat(kappaHistElem(elem,nLoadSteps:(nLoadSteps+unloadSize)))), abs(matFintL(2,nLoadSteps:(nLoadSteps+unloadSize))), 'g-o', 'linewidth', lw, 'markersize', ms)

labx = xlabel('Curvature'); laby = ylabel('M') ;
tit = title('M-\kappa');
set(labx, 'fontsize', plotFontSize*.5);
set(laby, 'fontsize', plotFontSize*.5);
set(tit, 'fontsize', plotFontSize);

% Solution check
% ------------------------------

P = abs(Fy) ;
I = b*h^3/12 ;

node = size(Nodes,1) ;
dof = node*2-1 ;

ffem = matUk(dof,2) 
theta_fem = matUk(dof+1,2)
M1fem = matFint(2,2) 

%~ My = sigmaY * b*h^2/6 
%~ Mp = sigmaY * b*h^2/4 
%~ kappa_e = 2*sigmaY/(E*h) 
disp('------------------------------------')

% Analytical solution
disp('First step') 
disp('------------------------------------')
Mana = P*L 
fana = P*L^3/(3*E*I)
theta_ana = P*L^2/(2*E*I)
disp('------------------------------------')



kappaPlElem = cell2mat(kappaPlHistElem(1,:)) ;
kappaPlaElem = cell2mat(kappaPlaHistElem(1,:)) ;
kappaElem = cell2mat(kappaHistElem(1,:)) ;

tb = 48 ; t1 = tb+1 ; t2 = t1+1 ;	

[ phiHistElem(1,tb) phiHistElem(1,t1) phiHistElem(1,t2) ]

vecKappa = [ kappaElem(tb) kappaElem(t1) kappaElem(t2) ]
vecKappaPl = [ kappaPlElem(tb-1) kappaPlElem(t1-1) kappaPlElem(t2-1) ]
vecKappaPla = [ kappaPlaElem(tb-1) kappaPlaElem(t1-1) kappaPlaElem(t2-1) ]

vecMe = E*I*(vecKappa - vecKappaPl)
vecPhi = abs(vecMe) - My
vecC = abs( 3*sigmaY ./ (vecKappa*h) .* ( 1 - kappa_e^2./(3*vecKappa.^2) ) ) 

%~ vecKappa = [ kappaElem(2) ]
%~ vecKappaPl = [ kappaPlElem(1) ]
%~ vecKappaPla = [ kappaPlaElem(1) ]

%~ vecMe = E*I*(vecKappa - vecKappaPl)
%~ vecPhi = abs(vecMe) - My

