% 

k = k+1 ;

% Assembly tangent stiffness matrix and internal force vector at current Uk
% ---------------------------------------
KTk 	= zeros(nnodes*ndofs, nnodes*ndofs) ;
FintkL = zeros(nnodes*ndofs, 1) ;
Fintk = zeros(nnodes*ndofs, 1) ;

for i=1:nelems
	
	% Elem nodes, dofs and geometry 
	nodeselem = Conec(i,1:2) ;
	elemdofs = nodes2dofs(nodeselem,ndofs) ;

	[R,l] = elemGeom( Nodes(nodeselem(1),:), Nodes(nodeselem(2),:), ndofs ) ;	
	b = secVec(Conec(i,3),1)	;
	h = secVec(Conec(i,3),2)	;
	I = b*h^3/12 ;
	
	% Elem nodes
	Xe = Nodes(nodeselem',:) ;
	
	% Elem disps in local system
	Uke = Uk(elemdofs) ;
	
	% Internal force
	[Finte, ~, Ck, ~, ~, ~] = beamInternLoad(Uke, Xe, R, l, b, h, modelParams, kappaPlHistElem(i,:), kappaPlaHistElem(i,:), time) ;
	
	FintkL(elemdofs) = Finte ;
	Fintk(elemdofs) = Fintk(elemdofs) + R * FintkL(elemdofs) ;
	
	% Tangent Stiffness Matrix in local system
	[Kloc] = stiffnessMatrix(Ck, I, l) ; 											
	
	% Assembly of Tangent stiffness matrix in global system 
	KTk(elemdofs,elemdofs) = KTk(elemdofs,elemdofs) + R*Kloc*R'  ;
	
end 


% Solve system
% ---------------------------------------
KTkred = KTk(free_gdl,free_gdl) ;
Fext_red = Fextk(free_gdl) ;
Fint_red = Fintk(free_gdl) ;

r = ( Fext_red - Fint_red ) ;

deltaUk = KTkred \ r ;

% Computes Uk
% ---------------------------------------
Uk(free_gdl) = Uk(free_gdl) + deltaUk ;

% Internal forces at converged Uk
% ---------------------------------------
FintkL = zeros(nnodes*ndofs, 1) ;
Fintk = zeros(nnodes*ndofs, 1) ;

for i = 1:nelems
	% Elem nodes, dofs and geometry 
	nodeselem = Conec(i,1:2) ;
	elemdofs = nodes2dofs(nodeselem,ndofs) ;
	[R,l] = elemGeom( Nodes(nodeselem(1),:), Nodes(nodeselem(2),:), ndofs ) ;
	b = secVec(Conec(i,3),1)	;
	h = secVec(Conec(i,3),2)	;
	I = b*h^3/12 ;
	
	% Elem disps in local system
	Uke = Uk(elemdofs) ;
	
	% Constitutive model
	[Finte, epsk, Ck, kappak, kappaPlk, kappaPlak, phik] = beamInternLoad(Uke, Xe, R, l, b, h, modelParams, kappaPlHistElem(i,:), kappaPlaHistElem(i,:), time) ;
																			
	epsHistElem(i,time+1) = epsk ;
	kappaHistElem(i,time+1) = kappak ;
	kappaPlHistElem(i,time+1) = kappaPlk ;
	kappaPlaHistElem(i,time+1) = kappaPlak ;
	phiHistElem(i,time+1) = phik ;
	
	% Internal force
	FintkL(elemdofs) = Finte ;
	Fintk(elemdofs) = Fintk(elemdofs) + R * FintkL(elemdofs) ;
	
end

% Check convergence
% ---------------------------------------

% Disps stop
normUk = norm(Uk(free_gdl)) ;
normDeltaUk = norm(deltaUk) ;

% Forces stop
norm_r  = norm(Fintk(free_gdl)-Fext_red ) ;
normFext = norm(Fext_red) ;

% Check convergence
if (k > tolk) 
	convIter = 1 ;
	cond = 1 ; % Iters
elseif ( normDeltaUk < tolu * normUk ) || ( norm_r < tolf * normFext )
	if ( normDeltaUk < tolu * normUk )
		convIter = 1 ;
		cond = 2 ; % Disps
	else
		convIter = 1 ;
		cond = 3 ; % Forces
	end	
end
	

