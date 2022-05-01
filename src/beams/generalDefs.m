% General internal defs
% ----------------------------------------------------------------------

% General
% ------------------------------
nnodes = size(Nodes,1) ;
nelems = size(Conec,1) ;
ndofs  = 2 ;
vec_gdl 	= (1:nnodes*ndofs)' ;

modelParams = [E, sigmaY, K] ; 

% Initialization of parameters
% ------------------------------
Uk = zeros(nnodes*ndofs,1) ;
Fextk = zeros(nnodes*ndofs,1) ;
Fintk = zeros(nnodes*ndofs, 1) ;
FintkL = zeros(nnodes*ndofs, 1) ;



matUk 	= [ Uk ] ; % Matrix to store disps
matFext = [ Fextk ] ; % Matrix to store applied external loads 
matFint = [ Fintk ] ; % Matrix to store applied external loads 
matFintL = [ FintkL ] ; % Matrix to store applied external loads 

time = 1 ;
nTimes = length(loadFactorsVec) ;

convParam = [] ;


% Supports
% ---------------------------------------
suppNodes = suppMatrix(:,1) ;
fixed_gdl = [] ;

for i = 1:length(suppNodes)

	for j = 1:ndofs
		if suppMatrix(i,j+1) == inf
			fixed_gdl = [ fixed_gdl ; nodes2dofs(suppNodes(i),ndofs)(j) ] ;
		end
	end
end

% Degrees of Freedom
% ---------------------------------------
fixed_gdl = unique(fixed_gdl) ;

free_gdl 	= vec_gdl ;
free_gdl(fixed_gdl) = [] ;

% Constitutive model parameters
% ---------------------------------------

epsHistElem = cell(nelems,nTimes) ;
kappaHistElem = cell(nelems,nTimes) ;
kappaPlHistElem = cell(nelems,nTimes) ;
kappaPlaHistElem = cell(nelems,nTimes) ;


epsHistElem(:,1) = 0 ;
kappaHistElem(:,1) = 0 ;
kappaPlHistElem(:,1) = 0 ;
kappaPlaHistElem(:,1) = 0 ;

% KTred cell
% ---------------------------------------

KTstore = cell(nTimes,1) ;
