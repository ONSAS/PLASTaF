% ----------------------------------------------------------------------
% Example of FEM - JIRASEK
% ----------------------------------------------------------------------

clear all, close all, clc

% Definitions

% Solver path
% ------------------------------

curr_path = pwd ;
solver_path = '../truss/' ;

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

% FEM
% ------------------------------

cd (solver_path)

solverFEM

cd (curr_path) 

% Solution check
% ------------------------------

lw = 2.0 ; ms = 11 ; plotFontSize = 22 ;

figure
grid on, hold on
plot(cell2mat(epsHistElem(2,1:nLoadSteps)), cell2mat(sigmaHistElem(2,1:nLoadSteps)), 'b-o', 'linewidth', lw, 'markersize', ms)

labx = xlabel('Strain'); laby = ylabel('Stress') ;
set(labx, 'fontsize', plotFontSize);
set(laby, 'fontsize', plotFontSize);
tit = title('\sigma-\epsilon');
set(tit, 'fontsize', plotFontSize);

% Analytical solution

S0 = abs(Fy) ;



% First Yield
'First Yield \n'
'------------------------------------'
t1 = 1.71 * S0 / 0.01 +1;
S11 = matFintL(1,t1) 
S21 = matFintL(1+2,t1) 
S31 = matFintL(1+4,t1)
Fext1 = matFext(4*2,t1)
'------------------------------------ \n'

% Second Yield
'Second Yield \n'
'------------------------------------'
t2 = 2.25 * S0 / 0.01 +1;
S12 = matFintL(1,t2) 
S22 = matFintL(1+2,t2) 
S32 = matFintL(1+4,t2)
Fext2 = matFext(4*2,t2)
'------------------------------------ \n'

% Third Yield
'Third Yield \n'
'------------------------------------'
t3 = 2.66 * S0 / 0.01 +1;
S13 = matFintL(1,t3) 
S23 = matFintL(1+2,t3) 
S33 = matFintL(1+4,t3)
Fext3 = matFext(4*2,t3)
'------------------------------------ \n'



