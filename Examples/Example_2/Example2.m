% ----------------------------------------------------------------------
% Example of FEM
% ----------------------------------------------------------------------

clear all, close all, clc

% Definitions

% Problem name
% ------------------------------
problemName = 'Example2_2bars_' ;

% Solver path
% ------------------------------

curr_path = pwd ;
solver_path = '../../src/truss/' ;

% Material parameters
% ------------------------------

sigmaY = 250 ; % Yield stress 
K = 8.5e3 ; % Linear hardening 

E = 210e3 ; % Elastic modulus
Et = E*K / ( E+K ) ; % Tangent modulus 


% Geometry variables
% ------------------------------

A1 = 100 ; 	% Element 1 section 
A2 = 200 ; 	% Element 2 section 

secVec = [ A1 ; A2 ] ;

l = 1000 ; % Length

Nodes =  [ 0 		0 ; ...
					 l 		0 ; ...
					 2*l 	0 ] ;

% Geometry variables
% ------------------------------

% Conec structure 
% [ nod1 nod2 A ]
Conec = [ 1 2 1 ; ...
					2 3 2 ] ;

% External forces 
% ------------------------------

% Global coordinate system
Fx = 2.5e3 ;
Fy = 0 ;

% nodalForceMatrix structure:
% [ node Fx Fy ]
nodalForceMatrix = [ 3 Fx Fy ] ; 

% Supports 
% ------------------------------

% Global coordinate system

% suppMatrix structure:
% [node kx ky ]
suppMatrix = [ 1 	inf 	inf ; ...
							 2 		0 	inf ; ...
							 3 		0 	inf	] ;


% Numerical method parameters
% ------------------------------

tolk = 50 	; % Number of iters
tolu = 1e-4 ; % Tolerance of converged disps
tolf = 1e-6 ; % Tolerance of internal forces
nLoadSteps = 31 ; % Number of load increments
 
loadFactorsVec = [ ones(nLoadSteps,1) ] ; 
 
epsPl0 	= 0 ;
epsPla0 = 0 ;
sigma0 = 0 ;

% Plot parameters
% ------------------------------
% Figure names
nameUndeformed = [ problemName 'Undeformed' ] ;
nameSigEps = [ problemName 'Stress-Strain' ] ;
nameDeformed = [ problemName 'Deformed' ] ;

% Deformed structure
plotsVec = [ 11 21 ] ;

% FEM
% ------------------------------

cd (solver_path)

solverFEM

cd (curr_path) 

% Plots
% ------------------------------

elem 				= 1 ;
plotLoadVec = [1:nLoadSteps] ;
scaleFactor = 10 ;

cd (solver_path)

plots

cd (curr_path) 

% Print figure
print( unDef	, [ nameUndeformed ] ,'-dpng') ;
print( sig_eps	, [ nameSigEps ] ,'-dpng') ;


% Solution check
% ------------------------------

% Analytical solution

gdl = 3*2-1 ;

% Fext = 25e3
F1 = matFext(gdl,11) 
eps1 = cell2mat(epsHistElem(1,10))
eps2 = cell2mat(epsHistElem(2,10))

eps1Ana = sigmaY/E 
eps2Ana = sigmaY/(2*E) 

err1 = (eps1-eps1Ana) / eps1Ana * 100 
err1 = (eps2-eps2Ana) / eps2Ana * 100 

% Fext = 50e3
F2 = matFext(gdl,21) 
eps1 = cell2mat(epsHistElem(1,20))
eps2 = cell2mat(epsHistElem(2,20))

eps1Ana = sigmaY/E + (sigmaY*A2/A1 - sigmaY) * 1 / Et  
eps2Ana = sigmaY/(E) 

err1 = (eps1-eps1Ana) / eps1Ana * 100 
err1 = (eps2-eps2Ana) / eps2Ana * 100 

