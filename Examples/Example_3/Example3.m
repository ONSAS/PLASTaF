% ----------------------------------------------------------------------
% Example of FEM - JIRASEK
% ----------------------------------------------------------------------

clear all, close all, clc

% Definitions

% Problem name
% ------------------------------
problemName = 'Example3_Jirasek_' ;


% Solver path
% ------------------------------

curr_path = pwd ;
solver_path = '../../src/truss/' ;

% Material parameters
% ------------------------------

sigmaY = 1 ; % Yield stress 
K = 0 ; % Linear hardening 
E = 1 ; % Elastic modulus

% Geometry variables
% ------------------------------

A = 1 ; 	% Element 1 section 


secVec = [ A ] ;

l = 1 ; % Length

Nodes =  [ 0 					0 ; ...
					 1.8*l 			0 ; ...
					 5.0*l 			0 ; ...
					 1.8*l -2.4*l ] ;

% Geometry variables
% ------------------------------

% Conec structure 
% [ nod1 nod2 A ]
Conec = [ 1 4 1 ; ...
					2 4 1 ; ...
					3 4 1 ] ;

% External forces 
% ------------------------------

% Global coordinate system
Fx = 0 ;
Fy = -A*sigmaY ;

% nodalForceMatrix structure:
% [ node Fx Fy ]
nodalForceMatrix = [ 4 Fx Fy ] ; 

% Supports 
% ------------------------------

% Global coordinate system

% suppMatrix structure:
% [node kx ky ]
suppMatrix = [ 1 	inf 	inf ; ...
							 2 	inf 	inf ; ...
							 3 	inf 	inf	] ;


% Numerical method parameters
% ------------------------------

tolk = 50 	; % Number of iters
tolu = 1e-4 ; % Tolerance of converged disps
tolf = 1e-6 ; % Tolerance of internal forces
nLoadSteps = 268 ; % Number of load increments
 
loadFactorsVec = [ 0.01*ones(nLoadSteps,1) ] ; 
 
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
plotsVec = [ 171 226 267 ] ;



% FEM
% ------------------------------

cd (solver_path)

solverFEM

cd (curr_path) 

% Plots
% ------------------------------

elem 				= 2 ;
plotLoadVec = [1:nLoadSteps] ;
scaleFactor = 1 ;

cd (solver_path)

plots

cd (curr_path) 

% Print figure
print( unDef	, [ nameUndeformed ] ,'-dpng') ;
print( sig_eps	, [ nameSigEps ] ,'-dpng') ;



% Solution check
% ------------------------------

% Analytical solution

S0 = abs(Fy) ;



% First Yield
disp('First Yield') 
disp('------------------------------------')
t1 = 1.71 * S0 / 0.01 +1;
S11 = matFintL(1,t1) 
S21 = matFintL(1+2,t1) 
S31 = matFintL(1+4,t1)
Fext1 = matFext(4*2,t1)
disp('------------------------------------')

% Second Yield
disp('Second Yield')
disp('------------------------------------')
t2 = 2.25 * S0 / 0.01 +1;
S12 = matFintL(1,t2) 
S22 = matFintL(1+2,t2) 
S32 = matFintL(1+4,t2)
Fext2 = matFext(4*2,t2)
disp('------------------------------------')

% Third Yield
disp('Third Yield')
disp('------------------------------------')
t3 = 2.66 * S0 / 0.01 +1;
S13 = matFintL(1,t3) 
S23 = matFintL(1+2,t3) 
S33 = matFintL(1+4,t3)
Fext3 = matFext(4*2,t3)
disp('------------------------------------')



